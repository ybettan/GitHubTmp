#!/bin/bash

#oc delete namespace minio
#oc delete namespace observatorium

oc delete configmap/cluster-monitoring-config -n openshift-monitoring
oc delete secret/remote-write-key-cert-ca -n openshift-monitoring
