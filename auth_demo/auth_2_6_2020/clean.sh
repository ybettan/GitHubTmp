#!/bin/bash

oc delete configmap/cluster-monitoring-config -n openshift-monitoring
oc delete secret/prometheus-k8s-remote-write -n openshift-monitoring
oc delete route/observatorium-xyz-observatorium-api -n observatorium
