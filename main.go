package main

import (
	"bytes"
	"fmt"
	"strings"
	"text/template"
)

const templateData = `apiVersion: machineconfiguration.openshift.io/v1
kind: MachineConfig
metadata:
  name: {{ .ROLE }}-{{ .MODE }}
  labels:
    machineconfiguration.openshift.io/role: {{ .ROLE }}
spec:
  config:
    ignition:
      version: 3.2.0
    storage:
      luks:
        - name: root
          device: /dev/disk/by-partlabel/root
          clevis:
		  {{- if eq .MODE "tpm" }}
            tpm2: true
		  {{- else if eq .MODE "tang" }}
            tang: {{ .TANG_INFO }}
		  {{- end }}
          options: [--cipher, aes-cbc-essiv:sha256]
          wipeVolume: true
      filesystems:
        - device: /dev/mapper/root
          format: xfs
          wipeFilesystem: true
          label: root
{{- if eq .MODE "tang" }}
  kernelArguments:
    - rd.neednet=1
{{- end }}
`

type TangInfo struct {
	url        string
	thumbprint string
}

type DiskEncryption struct {
	EnableOn string
	Mode     string
	TangInfo []*TangInfo
}

func main() {

	de := DiskEncryption{
		TangInfo: []*TangInfo{
			{
				url:        "http://tang.example.com:7500",
				thumbprint: "PLjNyRdGw03zlRoGjQYMahSZGu9",
			},
			{
				url:        "http://tang.example.com:7501",
				thumbprint: "PLjNyRdGw03zlRoGjQYMahSZGu8",
			},
			{
				url:        "http://tang.example.com:7502",
				thumbprint: "PLjNyRdGw03zlRoGjQYMahSZGu7",
			},
		},
	}

	var tangInfo string
	for _, ti := range de.TangInfo {
		tangInfo += fmt.Sprintf("\n%s- url: %s\n%sthumbprint: %s", strings.Repeat(" ", 14), ti.url, strings.Repeat(" ", 16), ti.thumbprint)
	}

	p := map[string]string{
		"ROLE":      "master",
		"MODE":      "tang",
		"TANG_INFO": tangInfo,
	}
	p["NAME"] = p["ROLE"] + "-" + p["MODE"]

	tmpl, err := template.New("template").Parse(templateData)
	if err != nil {
		panic(err.Error())
	}

	buf := &bytes.Buffer{}
	if err = tmpl.Execute(buf, p); err != nil {
		panic(err.Error())
	}

	fmt.Println(buf)
}
