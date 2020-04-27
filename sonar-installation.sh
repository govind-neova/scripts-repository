#!/bin/bash

#Install the java package
echo "Installing openjdk-11-jre-headless ,git ,unzip packages"

apt-get update
apt install openjdk-11-jre-headless -y
apt install git -y
apt install unzip -y

#for i in openjdk-11-jre-headless unzip git
#do
#	dpkg -s $i &> /dev/null
#	echo $?
#	if [ $? -eq 0 ]
#	then 
#		echo "Package $i is installed!"
#	else
#		echo "Installing $i package"
#		apt-get update
#		apt install $i -y
#	fi
#done

#dpkg -s openjdk-11-jre-headless &> /dev/null && dpkg -s unzip &> /dev/null && dpkg -s git &> /dev/null
#if [ $? -eq 0 ] 
#then
#    echo "Packages openjdk-11-jre-headless ,git ,unzip packages are installed!"
#else
#    echo "Package openjdk-11-jre-headless is NOT installed!"
#    echo "Installing openjdk-11-jre-headless package"
#    apt install openjdk-11-jre-headless -y 
#fi

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


#Installing sonar-scanner

echo "Installing sonar-scanner"

echo "Checking if sonarscanner latest version exist or not"
if [ -f sonar-scanner-cli-4.2.0.1873-linux.zip ]
then 
	echo "zip file already exist"
else
	echo "Installing and unzipping sonar-scanner"
        wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.2.0.1873-linux.zip
   	unzip sonar-scanner-cli-4.2.0.1873-linux.zip
fi

#Running sonar-scanner

echo "Installing sonar scanner in /opt sonar-scanner directory"

if [ -d /opt/sonar-scanner ]
then
	echo "directory /opt/sonar-scanner already exist"
else
	mv sonar-scanner-4.2.0.1873-linux /opt/sonar-scanner
fi

#Set Environmental variables
echo "Kindly enter username for git account"
read -p 'Username: ' uservar
echo "Kindly enter password for git account"
read -sp 'Password: ' passvar
echo $uservar

git clone https://$uservar:$passvar@$1
