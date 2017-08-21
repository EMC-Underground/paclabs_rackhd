#!/bin/bash

apt update
apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    ntp \
    ntpdate \
    git
service ntp stop
ntpdate -s mickey.lss.emc.com
service ntp start
sysctl -w vm.max_map_count=262144
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
apt update -y
apt install -y docker-ce
curl -o /usr/local/bin/docker-compose -L "https://github.com/docker/compose/releases/download/1.11.2/docker-compose-$(uname -s)-$(uname -m)"
chmod +x /usr/local/bin/docker-compose
git clone https://github.com/RackHD/RackHD.git /var/lib/rackhd
cp -f /tmp/docker-compose.yml /var/lib/rackhd/docker
TAG=latest docker-compose -f /var/lib/rackhd/docker/docker-compose.yml pull
TAG=latest docker-compose -f /var/lib/rackhd/docker/docker-compose.yml up -d
