#!/bin/bash

oc delete configmap/cluster-monitoring-config -n openshift-monitoring
oc delete secret/prometheus-k8s-remote-write -n openshift-monitoring

OVERRIDE='[{"group": "extensions/v1beta1", "kind": "Deployment", "name": "cluster-monitoring-operator", "namespace": "openshift-monitoring", "unmanaged": false}]'
oc patch clusterversion/version --type=json -p="[{\"op\": \"add\", \"path\": \"/spec/overrides\", \"value\": $OVERRIDE }]"
oc -n openshift-monitoring scale --replicas=1 deployment/cluster-monitoring-operator
