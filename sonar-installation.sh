#!/bin/bash

#Install the java package
echo "Checking openjdk-11-jre-headless package is installed or not"

dpkg -s openjdk-11-jre-headless &> /dev/null
if [ $? -eq 0 ] 
then
    echo "Package openjdk-11-jre-headless is installed!"
else
    echo "Package openjdk-11-jre-headless is NOT installed!"
    echo "Installing openjdk-11-jre-headless package"
    apt install openjdk-11-jre-headless -y 
fi

#Installing the sonarqube 8.2 version
echo "checking if  sonarqube 8.2 version zip file exist or not"

if [ -f sonarqube-8.2.0.32929.zip ]
then
	echo "File sonarqube-8.2.0.32929.zip already exist"
else
	echo "downloading sonarqube 8.2 version and unzipping it"
	wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.2.0.32929.zip
	unzip sonarqube-8.2.0.32929.zip
fi

if [ ! -d /opt/sonarqube  ]
then
	echo "Creating directory /opt/sonarqube"
	mv sonarqube-8.2.0.32929 /opt/sonarqube
else
	echo "directory already exist kindly delete..terminating the operation"
	#exit 1
fi

#Creating the sonarqube user
echo "Checking if sonarqube user exist or not"

id sonarqube &> /dev/null
if [ $? -eq 0 ]
then
	echo "User sonarqube already exist"
	chown -R sonarqube:sonarqube /opt/sonarqube
else
	echo "Creating sonarqube user"
	useradd sonarqube -s /bin/bash
	echo "changing permissions of /opt/sonarqube directory"
	chown -R sonarqube:sonarqube /opt/sonarqube
fi	

#Running the sonarqube server as sonarqube user
sudo -u  sonarqube bash -c ' sh /opt/sonarqube/bin/linux-x86-64/sonar.sh start '

