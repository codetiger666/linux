#!/bin/bash
yum install wget -y
cd /opt
wget -P /bin https://git.yzjx.tk:444/niening/linuxscripts/raw/branch/master/src/linux/docker/docker-compose
chmod +x /bin/docker-compose
