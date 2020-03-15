#!/bin/bash

wait_for_cr() {
    observatorium_cr_status=""
    target_status="Finished"
    timeout=$true
    interval=0
    intervals=600
    while [ $interval -ne $intervals ]; do
      echo "Waiting for" $1 "currentStatus="$observatorium_cr_status
      observatorium_cr_status=$(oc -n observatorium get observatoria.core.observatorium.io $1 -o=jsonpath='{.status.conditions[*].currentStatus}')
      if [ "$observatorium_cr_status" = "$target_status" ]; then
        echo $1 CR status is now: $observatorium_cr_status
	    timeout=$false
	    break
	  fi
	  sleep 5
	  interval=$((interval+5))
    done

    if [ $timeout ]; then
      echo "Timeout waiting for" $1 "CR status to be " $target_status
      exit 1
    fi
}

echo ""
echo "Build Minio S3 endpoint"
echo ""

oc create namespace observatorium
oc create -n observatorium -f https://raw.githubusercontent.com/nmagnezi/configuration/observatorium-operator/environments/dev/manifests/minio-secret.yaml
oc create -n observatorium -f https://raw.githubusercontent.com/nmagnezi/configuration/observatorium-operator/environments/dev/manifests/minio-pvc.yaml
oc create -n observatorium -f https://raw.githubusercontent.com/nmagnezi/configuration/observatorium-operator/environments/dev/manifests/minio-deployment.yaml
oc create -n observatorium -f https://raw.githubusercontent.com/nmagnezi/configuration/observatorium-operator/environments/dev/manifests/minio-service.yaml

echo ""
echo "RBAC configuration"
echo ""
oc create -f https://raw.githubusercontent.com/nmagnezi/configuration/observatorium-operator/deploy/cluster_role.yaml
oc create -f https://raw.githubusercontent.com/nmagnezi/configuration/observatorium-operator/deploy/cluster_role_binding.yaml

echo ""
echo "Install CRDs"
echo ""
oc create -f https://raw.githubusercontent.com/nmagnezi/configuration/observatorium-operator/deploy/crds/core.observatorium.io_observatoria.yaml

echo ""
echo "Install Operator"
echo ""
oc create -n default -f https://raw.githubusercontent.com/nmagnezi/configuration/observatorium-operator/deploy/operator.yaml

echo ""
echo "Deploy an example CR"
echo ""
oc -n observatorium create -f https://raw.githubusercontent.com/nmagnezi/configuration/observatorium-operator/example/core_v1alpha1_observatorium.yaml

echo ""
echo "Wait for CR"
echo ""
wait_for_cr observatorium-xyz

echo ""
echo "Expose API to allow Metrics from spokes"
echo ""
oc expose service/observatorium-xyz-observatorium-api-gateway -n observatorium --name observatorium-api-gateway

echo ""
echo "Set IPTables to for Observatorium API"
echo ""
CRC_IP=$(crc ip)
sudo iptables -I FORWARD -p tcp -m tcp --sport 80 -j ACCEPT
sudo iptables -I FORWARD -p tcp -m tcp --dport 80 -j ACCEPT
sudo iptables -t nat -I PREROUTING -p tcp -d 10.19.41.1 --dport 80 -j DNAT --to-destination $CRC_IP:80
