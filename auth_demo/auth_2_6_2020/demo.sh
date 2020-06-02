
# * this demo is based on unmerged pathces to prometheus-operator and observatorium-operator

# observatorium-operator (Nir Magnezi)
oc get secret/observatorium-api-tls-secret -n observatorium -o yaml
oc get observatorium/observatorium-xyz -n observatorium -o yaml | less 			# search for <secret>

# prometheus-operator
oc get secret/prometheus-k8s-remote-write -n openshift-monitoring -o yaml
oc get cm/cluster-monitoring-config -n openshift-monitoring -o yaml

# show grafana dashboard
# * not part of the monitoring stack - stand alone
