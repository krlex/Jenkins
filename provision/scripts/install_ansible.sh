#!/bin/sh

apt -y update && apt-get -y upgrade
apt-get install software-properties-common
apt-add-repository ppa:ansible/ansible -y

apt-get update
apt-get install ansible -y

apt-get install expect -y
apt-get install dos2unix -y
apt-get install tree -y

apt-get -y autoremove

ln -sf /usr/share/zoneinfo/Asia/Singapore /etc/localtime
usermod -aG sudo vagrant

echo "vagrant        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

# Disable daily apt unattended updates.
#echo 'APT::Periodic::Enable "0";' >> /etc/apt/apt.conf.d/10periodic

# echo vagrant | sudo -S su - vagrant -c "ssh-keygen -t rsa -f /home/vagrant/.ssh/id_rsa -q -P ''"
