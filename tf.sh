#!/bin/zsh
set -ex
if [ -f jenkins_package.tar.gz ]
then
   rm jenkins_package.tar.gz
fi

tar czvf jenkins_package.tar.gz plugins.sh plugins.txt jenkins.jks ca.crt install_jenkins.sh

terraform apply -auto-approve
