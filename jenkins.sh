#!/usr/bin/env bash

echo "Pre-Install common"
sudo apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common gcc g++ make tmux python3-pip > /dev/null 2>&1

echo "Adding apt-keys"
wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
echo deb http://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash - /dev/null 2>&1
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list


echo "Installation Ansible"
pip3 install -y ansible > /dev/null 2>&1

echo "Updating apt-get"
sudo apt-get -qq update

echo "Installing default-java"
sudo apt-get -y install default-jre > /dev/null 2>&1
sudo apt-get -y install default-jdk > /dev/null 2>&1

echo "Install npm and yarn"
sudo apt-get install -y yarn nodejs > /dev/null 2>&1

echo "Installing git"
sudo apt-get -y install git > /dev/null 2>&1

echo "Installing git-ftp"
sudo apt-get -y install git-ftp > /dev/null 2>&1

echo "Installing docker"
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /dev/null 2>&1
sudo apt-get update > /dev/null 2>&1
sudo apt-get -y install docker-ce docker-ce-cli containerd.io > /dev/null 2>&1

echo "Enable and starting Docker"
sudo service docker start

echo "Installing jenkins"
sudo apt-get -y install jenkins > /dev/null 2>&1
sudo service jenkins start

sleep 1m

echo "Installing tomcat 8.5.39"
sudo apt install -y tomcat8 > /dev/null 2>&1
sudo mkdir /var/share/tomcat8/logs

echo "Downloading and Installing Maven"
echo "Downloading now ....."
sudo get https://www-us.apache.org/dist/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz -P /tmp > /dev/null 2>&1

echo "Starting installing..."
sudo tar xf /tmp/apache-maven-*.tar.gz -C /opt > /dev/null 2>&1
sudo ln -s /opt/apache-maven-3.6.0 /opt/maven
echo "export JAVA_HOME=/usr/lib/jvm/default-java" > /etc/profile.d/maven.sh
echo "export M2_HOME=/opt/maven" >> /etc/profile.d/maven.sh
echo "export MAVEN_HOME=/opt/maven" >> /etc/profile.d/maven.sh
echo "export PATH=${M2_HOME}/bin:${PATH}" >> /etc/profile.d/maven.sh
sudo chmod +x /etc/profile.d/maven.sh
source /etc/profile.d/maven.sh
sudo apt install maven > /dev/null 2>&1
echo "DONE with Installation of maven"


echo "Password is:"
JENKINSPWD=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)
echo $JENKINSPWD

echo "URL address"
URL=$(sudo ip -4 addr show enp0s8 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
echo "http://"$URL":8080"
