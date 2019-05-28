#!/bin/bash
# Proper header for a Bash script.
# Ref http://diybigdata.net/2017/11/upgrading-odroid-cluster-to-ubuntu-16-04/
# Login as 'root' user
if [[ $(whoami) != 'root' ]]; then echo "Please run as 'root' user"; exit 1; fi

hostname="$1"
if [[ -z ${hostname} ]]; then
    echo "  1st param hostname is required. Valid value: master, slave1, slave2, slave3, slaveX"
    echo "  E.g.: ./setup-node.sh master"
    exit 1
fi

# Fix perl complaining error of some missing locales. See https://gist.github.com/panchicore/1269109
locale-gen en_US.UTF-8

# Create user 'odroid' in sudo group if not yet exists
id -u odroid &>/dev/null || {
	sleep 1
	useradd -p $(openssl passwd -1 odroid) odroid
	echo "Created user: odroid"
}
adduser odroid sudo
echo "Added user 'odroid' to sudo group"

sudo -H -u root bash -c "bash _apt-get-update.sh"

# Switch to user 'odroid'
#read -p "Switching to user 'odroid'..."
#su - odroid

# Install odroid utility
# 1. Resize the Boot Drive
# 2. Turn off Xorg
echo "[*] Installing odroid-utility.sh.. "
sleep 1
wget -O /usr/local/bin/odroid-utility.sh https://raw.githubusercontent.com/mdrjr/odroid-utility/master/odroid-utility.sh
chmod +x /usr/local/bin/odroid-utility.sh
read -p "[*] Modifying odroid-utility.sh. Do these 2 things: 1. Resize the Boot Drive; 2. Disable Xorg. Ready?..."
odroid-utility.sh

# change hostname
echo "[*] Setting hostname to: $hostname.."
sleep 1
echo ${hostname} > /etc/hostname
hostname ${hostname}
echo

# Override the whole /etc/hosts
cat hosts > /etc/hosts
echo '---- /etc/hosts ----'
cat /etc/hosts
echo '--------------------'
echo
sleep 1

# Append to /etc/sysctl.conf
echo '' >> /etc/sysctl.conf
cat sysctl.conf | while read -r line; do
    if [[ ${line} != '' ]]; then
        cnt=$(grep "$line" /etc/sysctl.conf | wc -l)
        if [[ ${cnt} -eq 0 ]]; then
            echo ${line} >> /etc/sysctl.conf
        fi
    fi
done
echo '---- /etc/sysctl.conf ----'
tail -10 /etc/sysctl.conf
echo '--------------------------'
echo
sleep 1

# Log eth* MAC addr
echo '------------------'
ifconfig -a
echo '------------------'
echo "[*] Important! Please log eth* MAC address to register with master node's DHCP server later "

# Done
read -p "[*] DONE [Enter] "

