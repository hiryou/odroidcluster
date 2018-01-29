#!/bin/bash
# Proper header for a Bash script.
# How to execute script under another user https://unix.stackexchange.com/questions/394461/linux-switch-user-and-execute-command-immediately

# Fix perl complaining error of some missing locales. See https://gist.github.com/panchicore/1269109
sudo locale-gen en_US.UTF-8

if [ $(hostname) = 'master' ]; then 
	read -p "[**] Run setup: Master node [Enter] "
	sudo -H -u odroid bash -c 'bash lan-master.sh' 
fi

