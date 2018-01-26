#!/bin/bash
# Proper header for a Bash script.
# Ref http://diybigdata.net/2017/11/upgrading-odroid-cluster-to-ubuntu-16-04/

# Fix perl complaining error of some missing locales. See https://gist.github.com/panchicore/1269109
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8
dpkg-reconfigure locales

# Create user 'odroid' in sudo group if not yet exists
id -u odroid &>/dev/null || {
	read -p "[*] Adding user 'odroid' as sudo user..."
	adduser odroid
	adduser odroid sudo
}

read -p "[*] Upgrading apts..."
apt-get update
apt-get upgrade
apt autoremove

#rm /var/lib/dpkg/lock    
#rm /var/cache/apt/archives/lock

# Switch to user 'odroid'
#read -p "Switching to user 'odroid'..."
#su - odroid

# Install odroid utility
# 1. Change the hostname
# 2. Turn off Xorg
# 3. Resize the Boot Drive
#sudo -s
read -p "[*] Now installing odroid-utility.sh..."
wget -O /usr/local/bin/odroid-utility.sh https://raw.githubusercontent.com/mdrjr/odroid-utility/master/odroid-utility.sh
chmod +x /usr/local/bin/odroid-utility.sh
read -p "[*] Modifying odroid-utility.sh, do these 3 things: Change hostname; Turn off Xorg; Resize the Boot Drive. Ready?..."
odroid-utility.sh

# Override the whole /etc/hosts
read -p "[*] Writing to /etc/hosts..."
cat hosts > /etc/hosts
# Append this to /etc/sysctl.conf
read -p "[*] Writing to /etc/sysctl.conf..."
cat sysctl.conf >> /etc/sysctl.conf

# Done
read -p "[*] Done. Now you can do: 'shutdown -h now'"

