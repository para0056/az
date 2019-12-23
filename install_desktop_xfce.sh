#!/bin/bash

# ===================================================================
# Purpose:           To automate the install of xRDP and XFCE.
# Parameters:        None
# Author:            Nick Paradis
# Notes:             Tested against Ubuntu 18.04-LTS on Microsoft Azure as a Linux Custom Script Extension.
# ===================================================================

# Update package list
apt-get update -y

# Install XRDP
apt-get install -y xrdp

# Disable newcursors because black background around cursor is displayed if using Xorg as session type.
sed -e 's/^new_cursors=true/new_cursors=false/g' -i /etc/xrdp/xrdp.ini
systemctl restart xrdp

# Install tasksel and use to install XFCE
apt-get install -y tasksel
tasksel install xubuntu-desktop

# Start the lightdm display manager
service lightdm start
