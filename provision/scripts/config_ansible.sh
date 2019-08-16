#!/bin/sh

USER=vagrant
PASSWORD=vagrant
DOMAIN={{ vagrant_domain_name }}

# add addresses to /etc/hosts
echo "192.168.99.155 ansible.{{ $DOMAIN }}" | sudo tee -a /etc/hosts
echo "192.168.99.154 gitlab.{{ $DOMAIN }}" | sudo tee -a /etc/hosts
echo "192.168.99.153 jenkins.{{ $DOMAIN }}" | sudo tee -a /etc/hosts
echo "192.168.99.152 docker.{{ $DOMAIN }}" | sudo tee -a /etc/hosts
echo "192.168.99.151 nfsclient.{{ $DOMAIN }}" | sudo tee -a /etc/hosts
echo "192.168.99.150 nfsserver.{{ $DOMAIN }}" | sudo tee -a /etc/hosts

echo " " | sudo tee -a /etc/ansible/hosts
echo "[all]" | sudo tee -a /etc/ansible/hosts
echo "gitlab.{{ $DOMAIN }}" | sudo tee -a /etc/ansible/hosts
echo "jenkins.{{ $DOMAIN }}" | sudo tee -a /etc/ansible/hosts
echo "docker.{{ $DOMAIN }}" | sudo tee -a /etc/ansible/hosts
echo "nfsclient.{{ $DOMAIN }}" | sudo tee -a /etc/ansible/hosts
echo "nfsserver.{{ $DOMAIN }}" | sudo tee -a /etc/ansible/hosts

echo " " | sudo tee -a /etc/ansible/hosts
echo "[test]" | sudo tee -a /etc/ansible/hosts
echo "nfsserver.{{ $DOMAIN }}" | sudo tee -a /etc/ansible/hosts
echo "nfsclient.{{ $DOMAIN }}" | sudo tee -a /etc/ansible/hosts

echo " " | sudo tee -a /etc/ansible/hosts
echo "[nfs-server]" | sudo tee -a /etc/ansible/hosts
echo "nfsserver.{{ $DOMAIN }}" | sudo tee -a /etc/ansible/hosts

echo " " | sudo tee -a /etc/ansible/hosts
echo "[nfs-client]" | sudo tee -a /etc/ansible/hosts
echo "nfsclient.{{ $DOMAIN }}" | sudo tee -a /etc/ansible/hosts

echo " " | sudo tee -a /etc/ansible/hosts
echo "[jenkins]" | sudo tee -a /etc/ansible/hosts
echo "jenkins.{{ $DOMAIN }}" | sudo tee -a /etc/ansible/hosts

echo " " | sudo tee -a /etc/ansible/hosts
echo "[docker]" | sudo tee -a /etc/ansible/hosts
echo "docker.{{ $DOMAIN }}" | sudo tee -a /etc/ansible/hosts

echo " " | sudo tee -a /etc/ansible/hosts
echo "[gitlab]" | sudo tee -a /etc/ansible/hosts
echo "gitlab.{{ $DOMAIN }}" | sudo tee -a /etc/ansible/hosts

#cat /etc/ansible/hosts
dos2unix provision/scripts/ssh_pass.sh
chmod +x provision/scripts/ssh_pass.sh
#chown vagrant:vagrant ssh_pass.sh

provision/scripts/ssh_pass.sh $USER $PASSWORD "ansible.{{ $DOMAIN }}"
provision/scripts/ssh_pass.sh $USER $PASSWORD "nfsclient.{{ $DOMAIN }}"
provision/scripts/ssh_pass.sh $USER $PASSWORD "nfsserver.{{ $DOMAIN }}"
provision/scripts/ssh_pass.sh $USER $PASSWORD "docker.{{ $DOMAIN }}"
provision/scripts/ssh_pass.sh $USER $PASSWORD "jenkins.{{ $DOMAIN }}"
provision/scripts/ssh_pass.sh $USER $PASSWORD "gitlab.{{ $DOMAIN }}"

ansible-playbook provision/playbooks/nfs_server.yaml
ansible-playbook provision/playbooks/nfs_clients.yaml
ansible-playbook provision/playbooks/install_java.yaml
ansible-playbook provision/playbooks/install_jenkins.yaml
ansible-playbook provision/playbooks/install_docker.yaml
ansible-playbook provision/playbooks/install_gitlab.yaml
