#!/bin/bash
# Proper header for a Bash script.
# Odroid xu3 board can only utilize gigabit internet through its usb 3.0 port. This setup is to explicitly turn off eth0 and use eth1 as primary ethernet interface

# Fix perl complaining error of some missing locales. See https://gist.github.com/panchicore/1269109
sudo locale-gen en_US.UTF-8

read -p "[*] Please plug a permanent ethernet dongle to the usb 3.0 port [Enter] "

echo '--------------------------------'
ifconfig -a
echo '--------------------------------'
read -p "[*] Remember eth0 and eth1's MAC addr as shown above [Enter] "

sudo touch /etc/udev/rules.d/70-persistent-net.rules
cat 70-persistent-net.rules | sudo tee /etc/udev/rules.d/70-persistent-net.rules > /dev/null
read -p "[*] Now modify 70-persistent-net.rules and map MAC addr to eth interfaces accordingly [Enter] "
sudo nano /etc/udev/rules.d/70-persistent-net.rules

read -p "[*] Writing to eth0 and eth1 [Enter] "
sudo touch /etc/network/interfaces.d/eth0
sudo touch /etc/network/interfaces.d/eth1
cat xu3/eth0 | sudo tee /etc/network/interfaces.d/eth0 > /dev/null
cat xu3/eth1 | sudo tee /etc/network/interfaces.d/eth1 > /dev/null

read -p "[*] This node will now shutdown. Then do this: Use the ethernet dongle to connect to internet, and turn on this node [Enter] "
shutdown -h now
