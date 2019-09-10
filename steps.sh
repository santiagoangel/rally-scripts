su
wget https://github.com/minishift/minishift/releases/download/v1.34.1/minishift-1.34.1-linux-amd64.tgz
tar -xzvf minishift-1.34.1-linux-amd64.tgz
cp minishift-1.34.1-linux-amd64/minishift /usr/local/bin
dnf install libvirt qemu-kvm
usermod -a -G libvirt student
su student
newgrp libvirt
exit
curl -L https://github.com/dhiltgen/docker-machine-kvm/releases/download/v0.10.0/docker-machine-driver-kvm-centos7 -o /usr/local/bin/docker-machine-driver-kvm
chmod +x /usr/local/bin/docker-machine-driver-kvm
systemctl start libvirtd
virsh net-list --all
minishift start --memory 8GB --public-hostname openshift.rally.redhat.com
###
minishift ip

vi /etc/hosts
systemctl restart dnsmasq

###

oc login https://openshift.rally.redhat.com:8443 --insecure-skip-tls-verify=true

git clone https://github.com/santiagoangel/rally-scripts
oc new-project rally
oc apply -f rally-scripts/application.yaml -n rally
oc new-project quarkus --description='Sample Quarkus App' --display-name='Sample Quarkus App'
oc new-build quay.io/quarkus/ubi-quarkus-native-s2i:19.1.1~https://github.com/santiagoangel/quarkus-quickstarts.git --context-dir=getting-started --name=quarkus-quickstart
oc new-app quarkus-quickstart
oc expose svc quarkus-quickstart
oc patch bc/quarkus-quickstart -p '{"spec":{"resources":{"limits":{"cpu":"2", "memory":"4Gi"}}}}'

