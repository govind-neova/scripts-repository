#!/bin/bash

#Setting PATH for sonar scanner
echo "setting path variable for sonar-scanner"
export SONAR_SCANNER_PATH=/opt/sonar-scanner/bin/sonar-scanner

#Install the java package
echo "Installing openjdk-11-jre-headless ,git ,unzip packages"

SONAR_PKG="openjdk-11-jre-headless unzip git"

for pkg in $SONAR_PKG;
do
	if dpkg --get-selections | grep -q "^$pkg[[:space:]]*install$" >/dev/null;
	then 
		echo "Package $pkg is installed!"
	else
		echo "Installing $pkg package"
		apt-get update
		apt install $pkg -y
	fi
done

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
	unzip sonar-scanner-cli-4.2.0.1873-linux.zip
else
	echo "Installing and unzipping sonar-scanner"
        wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.2.0.1873-linux.zip
   	unzip sonar-scanner-cli-4.2.0.1873-linux.zip
fi

#Running sonar-scanner

echo "Installing sonar scanner in /opt sonar-scanner directory"

if [ -d /opt/sonar-scanner ]
then
	echo "directory /opt/sonar-scanner already exist kindly delete it"
	exit 1;
else
	mv sonar-scanner-4.2.0.1873-linux /opt/sonar-scanner
fi

#GITHUB setup

function userpasswrdlogin () {
	
	echo "Kindly enter username for git account"
	read -p 'Username: ' uservar
	echo "Kindly enter password for git account"
	read -sp 'Password: ' passvar
	echo $uservar
	git clone https://$uservar:$passvar@github.com/govind-neova/gitproject.git

     }

function letmecreate () {

	echo "Exiting the script" 

     }

clear 
echo --------------------------------------------- 
echo "Kindly Enter Your Choice" 
echo --------------------------------------------- 
echo 1.Want to aceess repository using username and password
echo 2.Let me setup git at my own
echo Enter your choice 
read choice 
case $choice in
        1)userpasswrdlogin;;
        2)letmecreate;;
        *)echo This is not a choice
esac
