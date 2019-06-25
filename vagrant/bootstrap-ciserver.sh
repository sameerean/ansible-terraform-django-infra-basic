#!/usr/bin/env bash

VAGRANT_HOST_DIR=/home/vagrant/vagrant_jenkins

echo "======================================="
echo "Updating CentOs..."
echo "======================================="

sudo yum install -y epel-release
sudo yum -y update
sudo yum install -y net-tools
sudo yum install -y wget
sudo yum -y install unzip
sudo yum -y install git


echo "======================================="
echo "Installing OpenJDK 1.8 .."
echo "======================================="

sudo yum install -y java-1.8.0-openjdk.x86_64



echo "======================================="
echo "Setting up webadmin user..."
echo "======================================="

sudo groupadd --system webadmin
sudo mkdir /home/webadmin
sudo useradd --system --gid webadmin --shell /bin/bash --home /home/webadmin webadmin
sudo chown webadmin:webadmin /home/webadmin
cat <<EOF | sudo tee /etc/sudoers.d/webadmin
%webadmin ALL=(ALL) NOPASSWD: ALL
EOF


#echo "======================================="
#echo "Creating Apps Deploy directory.."
#echo "======================================="
#
#sudo mkdir -p /opt/apps-deploy/sample-django-for-ci
#sudo mkdir -p /opt/apps-deploy/logs
##sudo chmod 777 -R /opt/apps-deploy
#sudo chown webadmin:webadmin -R /opt/apps-deploy/

echo "======================================="
echo "Installing Jenkins .."
echo "======================================="

sudo yum clean all
sudo yum makecache fast

sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum install -y jenkins


echo "======================================="
echo " Changing Jenkins User .."
echo "======================================="
sudo sed -i 's/JENKINS_USER=\"jenkins\"/JENKINS_USER=\"webadmin\"/g' /etc/sysconfig/jenkins
sudo chown -R webadmin:webadmin /var/lib/jenkins
sudo chown -R webadmin:webadmin /var/cache/jenkins
sudo chown -R webadmin:webadmin /var/log/jenkins


echo "======================================="
echo "Installing Jenkins default user and config..."
echo "======================================="

sudo cp $VAGRANT_HOST_DIR/JenkinsConfig/config.xml /var/lib/jenkins/
sudo mkdir -p /var/lib/jenkins/users/admin
sudo cp $VAGRANT_HOST_DIR/JenkinsConfig/users/admin/config.xml /var/lib/jenkins/users/admin/
# sudo chown -R jenkins:jenkins /var/lib/jenkins/users/
sudo chown -R webadmin:webadmin /var/lib/jenkins
sudo chown -R webadmin:webadmin /var/cache/jenkins
sudo chown -R webadmin:webadmin /var/log/jenkins

# sudo usermod -a -G webadmin jenkins
# sudo usermod -a -G sudo jenkins


echo "======================================="
echo "Starting Jenkins Service .."
echo "======================================="

sudo service jenkins restart


echo "======================================="
echo "Installing Terraform...."
echo "======================================="

wget https://releases.hashicorp.com/terraform/0.12.2/terraform_0.12.2_linux_amd64.zip

sudo unzip ./terraform_0.12.2_linux_amd64.zip -d /usr/local/bin/

# yum -q list installed terraform &>/dev/null && echo "Terraform is installed" || echo "Terraform is not installed"
# TODO - Script on the above line doesn't work, come up with a way to verify the terraform installation


echo "======================================="
echo "Installing Terraform...."
echo "======================================="

sudo yum -y install ansible



echo "======================================="
echo "Installing required Jenkins plugins...."
echo "======================================="

wget http://localhost:8080/jnlpJars/jenkins-cli.jar .
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth admin:admin install-plugin git matrix-auth workflow-aggregator docker-workflow blueocean credentials-binding docker-plugin -restart

# TODO Add plugins - multi-branch, ansible, docker




#sudo chown -R webadmin:webadmin /opt/apps-deploy/



echo "======================================="
echo "Vagrant provisioning complete."
echo "======================================="

