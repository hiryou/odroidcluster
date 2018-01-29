#!/bin/bash
# Proper header for a Bash script.
# How to execute script under another user https://unix.stackexchange.com/questions/394461/linux-switch-user-and-execute-command-immediately

# Fix perl complaining error of some missing locales. See https://gist.github.com/panchicore/1269109
sudo locale-gen en_US.UTF-8

read -p "[**] Run setup: Initial setup for all nodes [Enter] "
sudo -H -u root bash -c 'bash lan-all.sh' 

if [ $(hostname) = 'master' ]; then 
	read -p "[**] Run setup: DHCP authoritative server [Enter] "
	sudo -H -u odroid bash -c 'bash lan-dhcp-server.sh' 
fi

read -p "[**] Now shutdown this node [Enter] "
sudo shutdown -h now

