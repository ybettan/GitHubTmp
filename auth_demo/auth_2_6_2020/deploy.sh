#!/bin/bash


oc -n openshift-monitoring create secret generic prometheus-k8s-remote-write \
    --from-file ~/certs/client.key \
    --from-file ~/certs/client.pem \
    --from-file ~/certs/ca.pem

oc expose svc/observatorium-xyz-observatorium-api -n observatorium

observatoriu_svc_ip=`oc get svc/observatorium-xyz-observatorium-api -n observatorium \
    | tr -s " " | tail -1 | cut -d" " -f3`

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
              name: prometheus-k8s-remote-write
              key: client.key
            cert:
              secret:
                name: prometheus-k8s-remote-write
                key: client.crt
            ca:
              secret:
                name: prometheus-k8s-remote-write
                key: ca.crt
" | oc apply -f -

oc scale --replicas=1 statefulset --all -n openshift-monitoring; \
    oc scale --replicas=1 deployment --all -n openshift-monitoring

OVERRIDE='[{"group": "extensions/v1beta1", "kind": "Deployment", "name": "cluster-monitoring-operator", "namespace": "openshift-monitoring", "unmanaged": true}]'
oc patch clusterversion/version --type=json -p="[{\"op\": \"add\", \"path\": \"/spec/overrides\", \"value\": $OVERRIDE }]"
oc -n openshift-monitoring scale --replicas=0 deployment/cluster-monitoring-operator
