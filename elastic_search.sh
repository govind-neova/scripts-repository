#!/bin/bash

#Install the java package
echo "Installing openjdk-11-jre-headless ,git ,unzip packages"

pkg="java-1.8.0-openjdk" 
if rpm -q $pkg
then
    echo "$pkg installed"
else
    echo "$pkg NOT installed"
    sudo yum -y install java-1.8.0-openjdk
fi

#setting environmental variables
export JAVA_HOME=/bin/java

#installing the elastic search rpms and setting repository
sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
cat > /etc/yum.repos.d/elasticsearch.repo << "EOF"
[elasticsearch-6.x]
name=Elasticsearch repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF

#install elastisearch and deploy
sudo yum -y install elasticsearch

#changing configurations for elasticsearch
sed -i -e 's/Xms1g/Xms512m/g' -e 's/Xmx1g/Xmx512m/g' /etc/elasticsearch/jvm.options
#echo "cluster.name: elasticsearch" >> /etc/elasticsearch/elasticsearch.yml 
#echo "cluster.routing.allocation.disk.threshold_enabled: true" >> /etc/elasticsearch/elasticsearch.yml 
#echo "cluster.routing.allocation.disk.watermark.flood_stage: 5gb" >> /etc/elasticsearch/elasticsearch.yml 
#echo "cluster.routing.allocation.disk.watermark.low: 20gb" >> /etc/elasticsearch/elasticsearch.yml 
#echo "cluster.routing.allocation.disk.watermark.high: 15gb" >> /etc/elasticsearch/elasticsearch.yml 
#echo "xpack.security.enabled: true" >> /etc/elasticsearch/elasticsearch.yml 
#echo "xpack.security.transport.ssl.enabled: true" >> /etc/elasticsearch/elasticsearch.yml
#echo "network.host: 0.0.0.0" >> /etc/elasticsearch/elasticsearch.yml

#starting the service
sudo chkconfig --add elasticsearch
sudo -i service elasticsearch start
sudo -i service elasticsearch status
