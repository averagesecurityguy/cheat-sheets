#!/bin/bash

#----------------------------------------------------------------------------
# The Kali light distro is a minimal install that requires some extra steps
# to install the necessary tools. This script will do the following:
#
#   * Install packages needed to build the VirtualBox Guest Additions
#   * Install the VirtualBox Guest Additions
#   * Install the Kali top 10 tools and set a random password on the MySQL
#     database.
#   * Configure PostgreSQL to start on boot
#   * Initialize the MSF database
#   * Reboot the computer.
#
# Prior to running this script, insert the VirtualBox Guest Additions CD
#-----------------------------------------------------------------------------

echo "Updating packages"
apt-get update
apt-get -y upgrade

echo "Installing build tools and headers."
apt-get -y install build-essential linux-headers-$(uname -r)

echo "Installing the Virtual Box Guest Additions."
mount /media/cdrom
if [ ! -f "/media/cdrom/VBoxLinuxAdditions.run" ]; then
    echo "VirtualBox Guest Additions CD not mounted, skipping."
else
    /bin/bash /media/cdrom/VBoxLinuxAdditions.run
fi

echo "Installing Kali top 10 tools."
pass=$(head -c 24 /dev/urandom | base64)
echo "MySQL Root Password: $pass"
echo "mysql-server-5.5 mysql-server/root_password_again password $pass" | debconf-set-selections
echo "mysql-server-5.5 mysql-server/root_password password $pass" | debconf-set-selections
echo "wireshark-common/install-setuid false" | debconf-set-selections
apt-get -y install kali-linux-top10 seclists

echo "Configuring Metasploit Database"
/etc/init.d/postgresql start
update-rc.d postgresql enable
msfdb init

echo "Rebooting."
reboot
