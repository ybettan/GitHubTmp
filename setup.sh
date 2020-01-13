
# clone observatorium/configuration repo and the last PR
git clone https://github.com/observatorium/configuration.git
cd configuration
git fetch origin pull/72/head:pr-72
git checkout pr-72

# FIXME: can we determin k8s version at runtime ?
# update telemter StatefulSet to apiVersion: apps/v1
sed -i 's/v1beta2/v1/' environments/kubernetes/manifests/telemeter-memcached-statefulSet.yaml
sed -i 's/v1beta2/v1/' environments/kubernetes/manifests/telemeter-statefulSet.yaml

# ============================================
# make sure there is no already-existing VMs
# ============================================

# install kubectl to 'configuration' repo - this is a requierment for /tests/deploy.sh
curl -LO https://storage.googleapis.com/kubernetes-release/release/\
`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x kubectl

# deploy the cluster with decent amount of CPUs and MEMORY
cpus=`lscpu | grep "CPU(s)" | head -n1 | cut -d":" -f2 | sed -e 's/^[ \t]*//'`
memory=`cat /proc/meminfo | grep MemFree | cut -d":" -f2 | sed -e 's/^[ \t]*//' | cut -d" " -f1`
cpus=$(($cpus-4))
memory=$(($memory/1024/1024-16))
minikube start --cpus=$cpus --memory=${memory}gb
tests/deploy.sh

# expose thanos-receive and thanos-querier to the local host
./kubectl patch svc thanos-receive --type='json' -p '[{"op":"replace","path":"/spec/type","value":"NodePort"}]' -n observatorium 
./kubectl patch svc thanos-querier --type='json' -p '[{"op":"replace","path":"/spec/type","value":"NodePort"}]' -n observatorium

# FIXME: in root mode variable are not recognized and in minikube isn't running so we cannot delclare the variable there
# expose thanos-receive and thanos-querier to remote hosts (ROOT ACCESS REQUIRED)
minikube_ip=`minikube ip`
thanos_querier_port=`./kubectl get svc thanos-querier -n observatorium | tail -1 | cut -d":" -f2 | cut -d"/" -f1`
thanos_receive_port=`./kubectl get svc thanos-receive -n observatorium | tail -1 | cut -d":" -f2 | cut -d"/" -f1`
sudo -i

iptables -t nat -I PREROUTING -p tcp -d 10.19.41.1 --dport $thanos_querier_port -j DNAT \
    --to-destination $minikube_ip:$thanos_querier_port
iptables -I FORWARD -p tcp -m tcp --sport $thanos_qurier_port -j ACCEPT
iptables -I FORWARD -p tcp -m tcp --dport $thanos_qurier_port -j ACCEPT
#
## redirect all access to <svc/thanos-receive port> to <minikube ip>:<svc/thanos-receive port>
## and add firewall rules for svc/thanos-receiver (in and out)
iptables -t nat -I PREROUTING -p tcp -d 10.19.41.1 --dport 32502 -j DNAT \
    --to-destination $minikube_ip:$thanos_receive_port
iptables -I FORWARD -p tcp -m tcp --sport $thanos_receive_port -j ACCEPT
iptables -I FORWARD -p tcp -m tcp --dport $thanos_receive_port -j ACCEPT
iptables -I FORWARD -p tcp -m tcp --sport 32502 -j ACCEPT
iptables -I FORWARD -p tcp -m tcp --dport 32502 -j ACCEPT
#
## test connection from my mac with curl and GUI
#curl bkr-hv01.dsal.lab.eng.bos.redhat.com:32502 (host is 10.19.41.1)

