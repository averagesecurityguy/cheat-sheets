#!/bin/sh

echo "Installing build tools and headers."
apt-get update
apt-get upgrade
apt-get install build-essential linux-headers-$(uname -r)

echo "Installing the Virtual Box Guest Additions."
echo "Insert the VirtualBox Guest Additions CD."
mount /media/cdrom
sh /media/cdrom/VBoxLinuxAdditions.run

echo "Installing Kali top 10 tools."
pass=$(head -c 24 /dev/urandom | base64)
echo "MySQL Root Password: $pass"
debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password_again password $pass"
debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password password $pass"
apt-get install kali-linux-top10 seclists

echo "Configuring Metasploit Database"
/etc/init.d/postgresql start
update-rc.d postgresql enable
msfdb init
