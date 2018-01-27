#!/bin/bash
# Proper header for a Bash script.
# How to execute script under another user https://unix.stackexchange.com/questions/394461/linux-switch-user-and-execute-command-immediately

# Fix perl complaining error of some missing locales. See https://gist.github.com/panchicore/1269109
sudo locale-gen en_US.UTF-8

read -p "[**] Run setup: all-node.sh [Enter] "
sudo -H -u root bash -c 'bash all-node.sh' 

if [ $(hostname) = 'master' ]; then 
	read -p "[**] Run setup: dhcp-nat-server.sh [Enter] "
	sudo -H -u odroid bash -c 'bash dhcp-nat-server.sh' 
fi

if [ $(hostname) = 'master' ]; then 
	read -p "[**] Run setup: master-cluster.sh [Enter] "
	sudo -H -u odroid bash -c 'bash master-cluster.sh' 
fi

