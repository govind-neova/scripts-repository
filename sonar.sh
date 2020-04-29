#!/bin/bash

project_name="lacework-repo1" 
echo $SONAR_SCANNER_PATH
#creating a folder
file=sonar_task
if  [ -d $file ]
then
         echo "$file exist already...removing the directory"
         rm -rf $file
else
         echo "$file does not exist"
fi

mkdir -p $file

cd $file

#################

if [ -z "$2" ]
then
	git clone "$1"
else
	git clone -b $2 $1
fi

cd `ls -d */`

touch sonar-project.properties

i1=sonar.projectKey=$project_name
i2=sonar.projectName=$project_name
i3=sonar.projectVersion=1.0
i4=sonar.sources=.

i1=$i1
i2=$i2
i3=$i3
i4=$i4

echo "$i1" >> sonar-project.properties
echo "$i2" >> sonar-project.properties
echo "$i3" >> sonar-project.properties
echo "$i4" >> sonar-project.properties

#run sonar-scanner
echo $SONAR_SCANNER_PATH
bash $SONAR_SCANNER_PATH
#/opt/sonar-scanner/bin/sonar-scanner
