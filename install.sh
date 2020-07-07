#! /bin/bash
apt update
apt install git -y
apt install docker.io -y
apt install unzip
apt install docker-compose -y
systemctl enable --now docker
wget -O  /usr/local/bin/docker-compose https://github.com/docker/compose/releases/download/1.25.0/docker-compose-Linux-x86_64

chmod +x /usr/local/bin/docker-compose
chmod 666 /var/run/docker.sock
sysctl -w vm.max_map_count=262144

apt install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
apt update
apt install -y kubelet kubeadm kubectl
kubeadm init

mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

sudo swapoff -a
#git clone https://github.com/levep/example-voting-app.git
#git clone https://github.com/levops-cloud/devops-jenkins.git
git clone https://github.com/ahikars/devops-jenkins.git


