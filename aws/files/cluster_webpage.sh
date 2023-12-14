#!/bin/sh
echo "Userdata start" > /tmp/userdata.txt
apt-get update
apt-get install apache2 mariadb-client -y
systemctl start apache2
systemctl status apache2
echo "Userdata end" >> /tmp/userdata.txt
