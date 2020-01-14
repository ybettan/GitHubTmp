
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

# expose thanos-receive and thanos-querier to remote hosts (ROOT ACCESS REQUIRED)
listening_port=32502
host_ip=`hostname -I | cut -d" " -f1`
minikube_ip=`minikube ip`
thanos_querier_port=`./kubectl get svc thanos-querier -n observatorium | tail -1 | cut -d":" -f2 | cut -d"/" -f1`
thanos_receive_port=`./kubectl get svc thanos-receive -n observatorium | tail -1 | cut -d":" -f2 | cut -d"/" -f1`

sudo --preserve-env=minikube_ip --preserve-env=host_ip --preserve-env=thanos_querier_port iptables -t nat -I PREROUTING \
    -p tcp -d $host_ip --dport $thanos_querier_port -j DNAT --to-destination $minikube_ip:$thanos_querier_port
sudo --preserve-env=thanos_querier_port iptables -I FORWARD -p tcp -m tcp --sport $thanos_querier_port -j ACCEPT
sudo --preserve-env=thanos_querier_port iptables -I FORWARD -p tcp -m tcp --dport $thanos_querier_port -j ACCEPT

sudo --preserve-env=minikube_ip --preserve-env=host_ip --preserve-env=thanos_receive_port --preserve-env=listening_port \
    iptables -t nat -I PREROUTING -p tcp -d $host_ip --dport $listening_port -j DNAT \
    --to-destination $minikube_ip:$thanos_receive_port
sudo --preserve-env=thanos_receive_port iptables -I FORWARD -p tcp -m tcp --sport $thanos_receive_port -j ACCEPT
sudo --preserve-env=thanos_receive_port iptables -I FORWARD -p tcp -m tcp --dport $thanos_receive_port -j ACCEPT
sudo --preserve-env=listening_port iptables -I FORWARD -p tcp -m tcp --sport $listening_port -j ACCEPT
sudo --preserve-env=listening_port iptables -I FORWARD -p tcp -m tcp --dport $listening_port -j ACCEPT

# test connection from my mac with curl and GUI at "bkr-hv01.dsal.lab.eng.bos.redhat.com:32502" (host is 10.19.41.1)

