#!/bin/bash
# Proper header for a Bash script.
# How to execute script under another user https://unix.stackexchange.com/questions/394461/linux-switch-user-and-execute-command-immediately

# Fix perl complaining error of some missing locales. See https://gist.github.com/panchicore/1269109
sudo locale-gen en_US.UTF-8

read -p "[**] Run setup: odroid-all-node.sh [Enter] "
sudo -H -u odroid bash -c 'bash odroid-all-node.sh' 

read -p "[**] Run setup: hduser-all-node.sh [Enter] "
sudo -H -u hduser bash -c 'bash hduser-all-node.sh' 
#sudo runuser -l hduser -c "bash $DIR/hduser-all-node.sh"

if [ $(hostname) = 'master' ]; then 
	read -p "[**] Run setup: hduser-master.sh [Enter] "
	sudo -H -u hduser bash -c 'bash hduser-master.sh' 
fi

