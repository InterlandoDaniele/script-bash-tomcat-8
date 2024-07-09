#!/bin/bash

apt update

apt install -y openjdk-21-jre-headless  #Y per confermare i cambiamenti

groupadd tomcat 

useradd -s /bin/false -g tomcat -d /home/tomcat tomcat

apt install -y unzip wget    #Y per confermare i cambiamenti

cd /tmp

wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.83/bin/apache-tomcat-8.5.83.tar.gz

tar xzvf apache-tomcat-8.5.83.tar.gz

mv apache-tomcat-8.5.83 /opt/tomcat

chown -R tomcat:tomcat /opt/tomcat

chmod +x /opt/tomcat/bin/*.sh

cat <<EOF > /etc/systemd/system/tomcat.service  
   
# scrivere quanto segue nel file tomcat.service
                        
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

Environment=JAVA_HOME=/usr/lib/jvm/java-1.21.0-openjdk-amd64
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

User=tomcat
Group=tomcat
UMask=0007
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target

EOF

chmod -R 755 /opt/tomcat

systemctl daemon-reload

systemctl enable tomcat.service

systemctl start tomcat.service

