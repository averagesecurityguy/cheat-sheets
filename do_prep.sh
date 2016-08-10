#!/bin/sh

# Copyright (c) 2014, LCI Technology Group, LLC
# All rights reserved.
# See LICENSE file for details.

#-----------------------------------------------------------------------------
#
# Script to prepare a new DigitalOcean Ubuntu or Debian install for first use.
# The script will do the following:
#   * Update the software
#   * Move the SSH server to a new port
#   * Disable password logins for SSH
#   * Configure iptables to block all incoming traffic except SSH
#   * Configure iptables to run at boot
#   * Create a new low-privilege user with sudo access.
#   * Copy the authorized key file for root to the new user.
#
# The script assumes you are using an SSH key for root login. If you are
# not the script may break your access to the server. Also, you really should
# be using SSH keys for all SSH access.
#
# After creating your DigitalOcean server, scp this file to the server, give
# it execute permissions with chmod +x do_prep.sh, and run it as root. When
# the script is complete, reboot the server. Once the server is back online
# you should be able to login with your low-privileged user account.
#
# Usage:
#   ./do_prep.sh username ssh_port
#-----------------------------------------------------------------------------

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 username ssh_port" >&2
  exit 1
fi

# Update the server
echo "Updating the server."
apt-get update
apt-get -y upgrade
apt-get -y autoremove

# Update the SSH configuration
echo "Reconfiguring SSH."
sed "s/Port 22/Port $2/" < /etc/ssh/sshd_config > /tmp/sshd_config
cp /tmp/sshd_config /etc/ssh/sshd_config
sed "s/#PasswordAuthentication yes/PasswordAuthentication no/" < /etc/ssh/sshd_config > /tmp/sshd_config
cp /tmp/sshd_config /etc/ssh/sshd_config
service ssh restart

# Add the firewall rules
echo "Adding new firewall rules."
iptables -A INPUT -i eth0 -p tcp --dport $2 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -i eth0 -p tcp -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -i eth0 -p udp --sport 53 -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP

# Configure iptables to start on boot
echo "Configuring firewall to start on boot."
iptables-save >> /etc/firewall.conf
touch /etc/network/if-up.d/iptables
chmod +x /etc/network/if-up.d/iptables
echo '#!/bin/sh' > /etc/network/if-up.d/iptables
echo 'iptables-restore < /etc/firewall.conf' >> /etc/network/if-up.d/iptables

# Add a new low-privileged user account
echo "Adding new low-privileged user account."
ssh-keygen -f user -N ""
pass=$(head -c 12 /dev/urandom | base64)
useradd -d /home/$1 -m -G sudo -s /bin/bash $1
echo $1:$pass | chpasswd
mkdir /home/$1/.ssh
mv user.pub /home/$1/.ssh/authorized_keys
chown -R $1:$1 /home/$1/.ssh

echo "User account $1 created with password $pass."
