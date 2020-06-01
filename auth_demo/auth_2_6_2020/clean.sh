#!/bin/bash

oc delete configmap/cluster-monitoring-config -n openshift-monitoring
oc delete secret/remote-write-key-cert-ca -n openshift-monitoring
