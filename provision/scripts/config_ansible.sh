#!/bin/sh

USER=vagrant
PASSWORD=vagrant
DOMAIN=example.com

echo "192.168.99.155 ansible.$DOMAIN " | sudo tee -a /etc/hosts
echo "192.168.99.154 gitlab.$DOMAIN " | sudo tee -a /etc/hosts
echo "192.168.99.153 jenkins.$DOMAIN " | sudo tee -a /etc/hosts
echo "192.168.99.152 docker.$DOMAIN " | sudo tee -a /etc/hosts
echo "192.168.99.151 nfsclient.$DOMAIN " | sudo tee -a /etc/hosts
echo "192.168.99.150 nfsserver.$DOMAIN " | sudo tee -a /etc/hosts

echo " " | sudo tee -a /etc/ansible/hosts
echo "[all]" | sudo tee -a /etc/ansible/hosts
echo "gitlab.$DOMAIN " | sudo tee -a /etc/ansible/hosts
echo "jenkins.$DOMAIN " | sudo tee -a /etc/ansible/hosts
echo "docker.$DOMAIN " | sudo tee -a /etc/ansible/hosts
echo "nfsclient.$DOMAIN " | sudo tee -a /etc/ansible/hosts
echo "nfsserver.$DOMAIN " | sudo tee -a /etc/ansible/hosts

echo " " | sudo tee -a /etc/ansible/hosts
echo "[test]" | sudo tee -a /etc/ansible/hosts
echo "nfsserver.$DOMAIN " | sudo tee -a /etc/ansible/hosts
echo "nfsclient.$DOMAIN " | sudo tee -a /etc/ansible/hosts

echo " " | sudo tee -a /etc/ansible/hosts
echo "[nfs-server]" | sudo tee -a /etc/ansible/hosts
echo "nfsserver.$DOMAIN " | sudo tee -a /etc/ansible/hosts

echo " " | sudo tee -a /etc/ansible/hosts
echo "[nfs-client]" | sudo tee -a /etc/ansible/hosts
echo "nfsclient.$DOMAIN " | sudo tee -a /etc/ansible/hosts

echo " " | sudo tee -a /etc/ansible/hosts
echo "[jenkins]" | sudo tee -a /etc/ansible/hosts
echo "jenkins.$DOMAIN " | sudo tee -a /etc/ansible/hosts

echo " " | sudo tee -a /etc/ansible/hosts
echo "[docker]" | sudo tee -a /etc/ansible/hosts
echo "docker.$DOMAIN " | sudo tee -a /etc/ansible/hosts

echo " " | sudo tee -a /etc/ansible/hosts
echo "[gitlab]" | sudo tee -a /etc/ansible/hosts
echo "gitlab.$DOMAIN " | sudo tee -a /etc/ansible/hosts

dos2unix provision/scripts/ssh_pass.sh
chmod +x provision/scripts/ssh_pass.sh
#chown vagrant:vagrant ssh_pass.sh

sudo provision/scripts/ssh_pass.sh $USER $PASSWORD "ansible.$DOMAIN "
sudo provision/scripts/ssh_pass.sh $USER $PASSWORD "nfsclient.$DOMAIN "
sudo provision/scripts/ssh_pass.sh $USER $PASSWORD "nfsserver.$DOMAIN "
sudo provision/scripts/ssh_pass.sh $USER $PASSWORD "docker.$DOMAIN "
sudo provision/scripts/ssh_pass.sh $USER $PASSWORD "jenkins.$DOMAIN "
sudo provision/scripts/ssh_pass.sh $USER $PASSWORD "gitlab.$DOMAIN "

sudo ansible-playbook provision/roles/nfs_server.yaml
sudo ansible-playbook provision/roles/nfs_clients.yaml
sudo ansible-playbook provision/roles/install_java.yaml
sudo ansible-playbook provision/roles/install_jenkins.yaml
sudo ansible-playbook provision/roles/install_docker.yaml
sudo ansible-playbook provision/roles/install_gitlab.yaml
