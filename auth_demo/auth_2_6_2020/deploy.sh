#!/bin/bash

#oc create namespace minio
#oc create namespace observatorium
#
##FIXME: make this a secret.yaml
#oc -n observatorium create secret generic tls-certs \
#    --from-file certs/server.pem \
#    --from-file certs/server.key \
#    --from-file certs/ca.pem

oc -n openshift-monitoring create secret generic remote-write-key-cert-ca \
    --from-file certs/client.pem \
    --from-file certs/client.key

#oc apply -f environments/dev/manifests/
oc expose svc/observatorium-xyz-observatorium-api-gateway -n observatorium

observatoriu_svc_ip=`oc get svc/observatorium-xyz-observatorium-api-gateway -n observatorium \
    | tr -s " " | tail -1 | cut -d" " -f3`

##FIXME: need to add clien cert and key to tlsConfig section - from secrets.
##       As for today prometheus operator don't make use of this secret according
##       to https://github.com/coreos/prometheus-operator/issues/3118
#echo "
#apiVersion: v1
#kind: ConfigMap
#metadata:
#  name: cluster-monitoring-config
#  namespace: openshift-monitoring
#data:
#  config.yaml: |
#    prometheusK8s:
#      remoteWrite:
#        - url: "https://$observatoriu_svc_ip:8080/api/metrics/v1/write"
#          writeRelabelConfigs:
#          - sourceLabels: [__name__]
#            replacement: seal18_OS_cluster # this is the name of the cluster
#            targetLabel: cluster
#          tlsConfig:
#            insecureSkipVerify: true
#" | oc apply -f -

echo "
apiVersion: v1
kind: ConfigMap
metadata:
  name: cluster-monitoring-config
  namespace: openshift-monitoring
data:
  config.yaml: |
    prometheusK8s:
      remoteWrite:
        - url: "https://$observatoriu_svc_ip:8080/api/metrics/v1/write"
          writeRelabelConfigs:
          - sourceLabels: [__name__]
            replacement: seal18_OS_cluster # this is the name of the cluster
            targetLabel: cluster
          tlsConfig:
            keySecret:
              name: remote-write-key-cert-ca
              key: client.key
            cert:
              secret:
                name: remote-write-key-cert-ca
                key: client.crt
            ca:
              secret:
                name: remote-write-key-cert-ca
                key: ca.crt
" | oc apply -f -

oc scale --replicas=1 statefulset --all -n openshift-monitoring; \
    oc scale --replicas=1 deployment --all -n openshift-monitoring
