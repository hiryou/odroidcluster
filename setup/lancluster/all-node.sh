#!/bin/bash
# Proper header for a Bash script.
# Ref http://diybigdata.net/2017/11/upgrading-odroid-cluster-to-ubuntu-16-04/
# Login as 'root' user
if [ $(whoami) != 'root' ]; then echo "Please run as 'root' user"; exit 1; fi

# Fix perl complaining error of some missing locales. See https://gist.github.com/panchicore/1269109
sudo locale-gen en_US.UTF-8

# Create user 'odroid' in sudo group if not yet exists
id -u odroid &>/dev/null || {
	read -p "[*] Add user 'odroid' as sudo user [Enter] "
	adduser odroid
	adduser odroid sudo
}

read -p "[*] Upgrade apts [Enter] "
apt-get update
apt-get upgrade
apt autoremove

sudo rm /var/lib/dpkg/lock    
sudo rm /var/cache/apt/archives/lock

# Switch to user 'odroid'
#read -p "Switching to user 'odroid'..."
#su - odroid

# Install odroid utility
# 1. Change the hostname
# 2. Turn off Xorg
# 3. Resize the Boot Drive
#sudo -s
while true; do
    read -p "[*] Install odroid-utility.sh? [y/n]: " yn
    case $yn in
        [Yy]* ) 
        	wget -O /usr/local/bin/odroid-utility.sh https://raw.githubusercontent.com/mdrjr/odroid-utility/master/odroid-utility.sh
			chmod +x /usr/local/bin/odroid-utility.sh
			read -p "[*] Modifying odroid-utility.sh. Do these 3 things: Change hostname; Turn off Xorg; Resize the Boot Drive. Ready?..."
			odroid-utility.sh
        	break;;
        [Nn]* ) break;;
        * ) ;;
    esac
done

# Override the whole /etc/hosts
echo '------------------'
cat hosts
echo '------------------'
read -p "[*] Write content above to /etc/hosts [Enter] "
cat hosts > /etc/hosts

# Append to /etc/sysctl.conf
echo '------------------'
cat sysctl.conf
echo '------------------'
read -p "[*] Appending content above to /etc/sysctl.conf [Enter] "
cat sysctl.conf >> /etc/sysctl.conf

# Log eth* MAC addr
echo '------------------'
ifconfig -a
echo '------------------'
read -p "[*] Please log eth* MAC addr for registering static IP addr with master node later [Enter] "

# Done
read -p "[*] DONE [Enter] "

