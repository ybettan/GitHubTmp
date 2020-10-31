package main

import (
	"fmt"
	"io/ioutil"
	"reflect"
	"strings"
	"time"

	"github.com/pkg/errors"
	"gopkg.in/yaml.v2"
)

type Labels struct {
	Role string `yaml:"machineconfiguration.openshift.io/role"`
}

type Metadata struct {
	CreationTimestamp time.Time `yaml:"creationTimestamp"`
	Labels            Labels    `yaml:"labels"`
	Name              string    `yaml:"name"`
}

type Ignition struct {
	Version string `yaml:"version"`
}

type User struct {
	Name              string   `yaml:"name"`
	SshAuthorizedKeys []string `yaml:"sshAuthorizedKeys"`
}

type Passwd struct {
	Users []User `yaml:"users"`
}

type Config struct {
	Ignition Ignition `yaml:"ignition"`
	Passwd   Passwd   `yaml:"passwd"`
}

type Spec struct {
	Config          Config `yaml:"config"`
	Fips            bool   `yaml:"fips"`
	KernelArguments string `yaml:"kernelArguments"`
	OsImageURL      string `yaml:"osImageURL"`
}

type MachineConfig struct {
	ApiVersion string   `yaml:"apiVersion"`
	Kind       string   `yaml:"kind"`
	Metadata   Metadata `yaml:"metadata"`
	Spec       Spec     `yaml:"spec"`
}

func ReadYaml(fromFile string, toObj interface{}) error {
	yamlFile, err := ioutil.ReadFile(fromFile)
	if err != nil {
		return errors.Errorf("Error reading YAML file: %s\n", err)
	}
	err = yaml.Unmarshal(yamlFile, toObj)
	if err != nil {
		errors.Errorf("Error parsing YAML file: %s\n", err)
		return err
	}
	return nil
}

func WriteYaml(fromObj interface{}, toFile string) error {
	resBytes, err := yaml.Marshal(fromObj)
	if err != nil {
		errors.Errorf("Error parsing YAML file: %s\n", err)
		return err
	}
	err = ioutil.WriteFile(toFile, resBytes, 0644)
	if err != nil {
		return errors.Errorf("Error writing YAML file: %s\n", err)
	}
	return nil
}

func parseField(s string) (string, bool, int) {
	if strings.HasSuffix(s, "]") {
		newS := strings.Split(s, "[")[0]
		index := int(s[len(s)-2] - '0')
		return newS, true, index
	} else {
		return s, false, 0
	}
}

func patchMastersIgnition(yamlFile, fieldName, newData, op string, yamlStruct interface{}) error {

	err := ReadYaml("in.yaml", yamlStruct)
	if err != nil {
		fmt.Printf("cannot read yaml: %s\n", err)
	}

	fieldNames := strings.Split(fieldName, ".")
	data := reflect.ValueOf(yamlStruct).Elem()
	for _, f := range fieldNames {
		newF, isList, index := parseField(f)
		data = data.FieldByName(newF)
		if isList {
			data = data.Index(index)
		}
	}

	data.Set(reflect.Append(data, reflect.ValueOf(newData)))

	//switch op {
	//case "append-list":
	//default:
	//	err := errors.Errorf("operation %s isn't supported\n", op)
	//	return err
	//}

	err = WriteYaml(yamlStruct, "out.yaml")
	if err != nil {
		fmt.Printf("cannot write yaml: %s\n", err)
	}

	return nil
}

func main() {

	var mc MachineConfig

	patchMastersIgnition("in.yaml", "Spec.Config.Passwd.Users[0].SshAuthorizedKeys",
		"new ssh key", "append-list", &mc)

	//mcs := structs.New(&mc)
	//fmt.Println(mcs.Field("Spec").Field("Config").Field("Passwd").Field("Users").Value().([]User)[0])
	//fmt.Printf("type: %T\nvalue: %v\n", reflect.ValueOf(mc), reflect.ValueOf(mc))
	//reflect.ValueOf(mc).FieldByName("Spec")
	//fmt.Println(reflect.ValueOf(mc).FieldByName(fields[0]).FieldByName(fields[1]).FieldByName(fields[2]).FieldByName("Users").Index(0).FieldByName("SshAuthorizedKeys").Index(0))

	//newSshKey := "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDd84cK8wIaqB7LKAfJ4354dkqe1sywdw9KehVdiupseMzrkmX72Kn2vtZwSYU+xQvmJPfJxOnGCH6DIjN4fwph8jLoQD3bw1b0pLc6vXFm5ekN3472BHHJHUcl22MXeOcLBVLiqr30sZ8WT7RFdwe9glu2W+RlVWetb/fUxQFm2ce67DmT1cVWWKtVGBcfKwavYGb+gs2EPX3vu0OVHO+yyVV/FaCDwUEzRrcg0O4NX5jL3nqd6kXvuVZv9yGIrAyeZUvAQYwf2Ls4/++Cp0Z1BVW2u54sTX2rE2OAQl+FxvFS28sHvlrDGB4ING/2s9nQ/Rb01riaSiP2Bc1OdTYt ybettan@dhcp-3-107.tlv.redhat.com"

}
