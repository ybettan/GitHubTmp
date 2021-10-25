package main

import (
	"bytes"
	"fmt"
	"text/template"
)

const originalData = `apiVersion: machineconfiguration.openshift.io/v1
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
            tang:{{ .TANG_SERVERS }}
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
{{- end }}`

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
            tang:
			{{- range .TANG_SERVERS }}
              - {{ .Url }}
                {{ .Thumbprint }}
			{{- end }}
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
{{- end }}`

type TangServer struct {
	Url        string
	Thumbprint string
}

//
//type DiskEncryption struct {
//	EnableOn    string
//	Mode        string
//	TangServers string
//}

func main() {

	//de := DiskEncryption{
	//	TangInfo: []*TangInfo{
	//		{
	//			url:        "http://tang.example.com:7500",
	//			thumbprint: "PLjNyRdGw03zlRoGjQYMahSZGu9",
	//		},
	//		{
	//			url:        "http://tang.example.com:7501",
	//			thumbprint: "PLjNyRdGw03zlRoGjQYMahSZGu8",
	//		},
	//		{
	//			url:        "http://tang.example.com:7502",
	//			thumbprint: "PLjNyRdGw03zlRoGjQYMahSZGu7",
	//		},
	//	},
	//}

	p := map[string]interface{}{
		"ROLE": "master",
		"MODE": "tang",
		"TANG_SERVERS": []TangServer{
			{
				Url:        "http://tang.example.com:7500",
				Thumbprint: "PLjNyRdGw03zlRoGjQYMahSZGu9",
			},
			{
				Url:        "http://tang.example.com:7501",
				Thumbprint: "PLjNyRdGw03zlRoGjQYMahSZGu8",
			},
		},
	}

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
