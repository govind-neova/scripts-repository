#!/bin/bash

echo $SONAR_SCANNER_PATH

echo "$1"
echo "$2"

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

#cloning the repository
echo "Cloning the git repository from URL $1"
cd $file
git clone "$1"

#function to check currently working branch

cd $2
BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [[ "$BRANCH" == "master" ]]; then
  echo "You are on master branch"
  #exit 1;
fi

##creating configuration files in directory

touch sonar-project.properties

i1=sonar.projectKey=puppeteer
i2=sonar.projectKey=puppeteer
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
#/opt/sonar-scanner/bin/sonar-scanner
$SONAR_SCANNER_PATH
