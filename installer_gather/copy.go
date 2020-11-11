package main

import (
	"os"
	"text/template"
)

const (
	sshManifest = `
apiVersion: machineconfiguration.openshift.io/v1
kind: MachineConfig
metadata:
  creationTimestamp: null
  labels:
    machineconfiguration.openshift.io/role: master
  name: 99-master-ssh
spec:
  config:
    ignition:
      version: 3.1.0
    passwd:
      users:
      - name: core
        sshAuthorizedKeys:
        - {{.}}
  fips: false
  kernelArguments: null
  kernelType:
  osImageURL:
`
)

func main() {
	f, _ := os.Create("test.txt")
	defer f.Close()
	t := template.Must(template.New("letter").Parse(sshManifest))
	t.Execute(f, "my new ssh key")
}
