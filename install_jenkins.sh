#!/bin/bash
set -ex

#avoid Jenkins to start normal setup wizard
export JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
sudo sh -c "echo 'JAVA_OPTS=-Djenkins.install.runSetupWizard=false' >>/etc/profile"

#mount S3 bucket with all necessary files
#

sudo yum -y -q install unzip git wget
sudo wget --no-check-certificate -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum install -y -q epel-release 
sudo yum install -y -q java-11-openjdk-devel
sudo yum install -y -q jenkins

#Install Basic plugins
sudo chmod +x plugins.sh
sudo systemctl stop jenkins
sudo mkdir -p /var/lib/jenkins/plugins
sudo chown -R jenkins:jenkins /var/lib/jenkins/plugins
sudo ./plugins.sh -p plugins.txt --plugindir /var/lib/jenkins/plugins

#prepare SSL for HTTPS
sudo mv jenkins.jks /var/lib/jenkins/jenkins.jks
sudo chown -R jenkins:jenkins /var/lib/jenkins
sudo mv ca.crt /etc/pki/ca-trust/source/anchors
sudo update-ca-trust

#prepare Jenkins files for HTTPS

#prepare iptables for HTTPS
sudo sh -c 'echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf'
sudo sh -c 'echo "net.ipv4.conf.eth0.route_localnet = 1" >> /etc/sysctl.conf'
sudo iptables -A INPUT -p tcp --dport 43000 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 8443 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 443
#sudo iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 443 -j REDIRECT --to-port 8443

#start Jenkins
sudo systemctl start jenkins 

#echo auth password
sudo sh -c "cat /var/lib/jenkins/secrets/initialAdminPassword"

echo "finished installing Jenkins"