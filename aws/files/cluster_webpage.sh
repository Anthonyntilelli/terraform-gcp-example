#!/bin/sh
echo "Userdata start" > /userdata.txt
apt-get update
apt-get install apache2 -y
systemctl start apache2
systemctl status apache2
echo "Userdata end" >> /userdata.txt
