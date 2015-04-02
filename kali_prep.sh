#!/bin/sh

# Copyright (c) 2015, LCI Technology Group, LLC
# All rights reserved.
# See LICENSE file for details.

#-----------------------------------------------------------------------------
#
# Script to prepare a new Kali install for first use.
# The script will do the following:
#   * Update the software
#   * Start the postgresql and metasploit services
#   * Configure the postgresql and metasploit services to start on boot
#
# Usage:
#   ./kali_prep.sh
#-----------------------------------------------------------------------------

# Update the server
echo "Updating the server."
apt-get update
apt-get -y upgrade
apt-get -y autoremove

# Starting Postgres and Metasploit services
echo "Starting services."
service postgresql start
service metasploit start

# Configure services to start on boot.
echo "Configure services to start on boot."
update-rc.d postgresql enable
update-rc.d metasploit enable

# Setup is complete
echo "New user account is ready to use."