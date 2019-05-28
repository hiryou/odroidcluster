#!/bin/bash
# Proper header for a Bash script.
# How to execute script under another user https://unix.stackexchange.com/questions/394461/linux-switch-user-and-execute-command-immediately

hostname="$1"
if [[ -z ${hostname} ]]; then
    echo "  1st param hostname is required. Valid value: master, slave1, slave2, slave3, slaveX"
    echo "  E.g.: ./setup-node.sh slave1"
    exit 1
fi

# Fix perl complaining error of some missing locales. See https://gist.github.com/panchicore/1269109
sudo locale-gen en_US.UTF-8

echo "[**] Running setup: Initial setup for all nodes.. "
sleep 1
sudo -H -u root bash -c "bash lan-all.sh $hostname"

if [[ $(hostname) = 'master' ]]; then
	echo "[**] Setup for master node: DHCP server.. "
	sudo -H -u odroid bash -c 'bash lan-dhcp-server.sh'
fi

read -p "[**] Finished setup for node: $hostname. Shutting down now. [Enter] "
sudo shutdown -h now

