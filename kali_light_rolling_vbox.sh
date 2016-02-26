#!/bin/bash

#----------------------------------------------------------------------------
# The Kali light distro is a minimal install that requires some extra steps
# to run it well in VirtualBox and to install the basic pentesting tools.
# This script will do the following:
#
#   * Install the VirtualBox Guest Additions package from the OS.
#   * Install the Kali top 10 tools and set a random password on the MySQL
#     database.
#   * Configure PostgreSQL to start on boot
#   * Initialize the MSF database
#
#-----------------------------------------------------------------------------
echo "Updating packages"
apt-get update
apt-get -y upgrade

echo "Installing Kali top 10 tools."
pass=$(head -c 24 /dev/urandom | base64)
echo "mysql-server-5.6 mysql-server/root_password_again password $pass" | debconf-set-selections
echo "mysql-server-5.6 mysql-server/root_password password $pass" | debconf-set-selections
echo "wireshark-common wireshark-common/install-setuid boolean false" | debconf-set-selections
apt-get -y install kali-linux-top10 seclists

echo "Configuring Metasploit Database"
/etc/init.d/postgresql start
update-rc.d postgresql enable
msfdb init

echo "Installing VirtualBox Guest Additions"
apt-get -y install virtualbox-guest-x11

echo "MySQL Root Password: $pass"
echo "Please reboot."
