#!/bin/bash

#----------------------------------------------------------------------------
# The Kali light distro is a minimal install that requires some extra steps
# to run it well in VirtualBox and to install the basic pentesting tools.
# This script will do the following:
#
#   * Install packages needed to build the VirtualBox Guest Additions
#   * Install the VirtualBox Guest Additions
#   * Install the Kali top 10 tools and set a random password on the MySQL
#     database.
#   * Configure PostgreSQL to start on boot
#   * Initialize the MSF database
#
# Prior to running this script, insert the VirtualBox Guest Additions CD
#-----------------------------------------------------------------------------
echo "Updating packages"
apt-get update
apt-get -q -y upgrade

echo "Installing build tools and headers."
apt-get -q -y install build-essential linux-headers-$(uname -r)

echo "Installing the VirtualBox Guest Additions."
read -p "Insert the VirtualBox Guest Additions CD and press [Enter] key..."
mount /media/cdrom
if [ ! -f "/media/cdrom/VBoxLinuxAdditions.run" ]; then
    echo "VirtualBox Guest Additions CD not mounted, skipping."
else
    /bin/bash /media/cdrom/VBoxLinuxAdditions.run
    umount /media/cdrom
    eject /media/cdrom
fi

echo "Installing Kali top 10 tools."
pass=$(head -c 24 /dev/urandom | base64)
echo "mysql-server-5.5 mysql-server/root_password_again password $pass" | debconf-set-selections
echo "mysql-server-5.5 mysql-server/root_password password $pass" | debconf-set-selections
echo "wireshark-common wireshark-common/install-setuid boolean false" | debconf-set-selections
apt-get -q -y install kali-linux-top10 seclists

echo "Configuring Metasploit Database"
/etc/init.d/postgresql start
update-rc.d postgresql enable
msfdb init

echo "MySQL Root Password: $pass"
echo "Please reboot."
