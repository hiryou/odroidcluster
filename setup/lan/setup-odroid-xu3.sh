#!/bin/bash
# Proper header for a Bash script.
# Odroid xu3 board can only utilize gigabit internet through its usb 3.0 port. This setup is to explicitly turn off eth0 and use eth1 as primary ethernet interface

# Fix perl complaining error of some missing locales. See https://gist.github.com/panchicore/1269109
sudo locale-gen en_US.UTF-8

sudo -H -u root bash -c "bash _apt-get-update.sh"

echo '--------------------------------'
ifconfig -a
echo '--------------------------------'
eth0mac=$(ifconfig -a | grep eth0 | egrep -o '.{2}:.{2}:.{2}:.{2}:.{2}:.{2}')
eth1mac=$(ifconfig -a | grep eth1 | egrep -o '.{2}:.{2}:.{2}:.{2}:.{2}:.{2}')
while [[ -z ${eth1mac} ]]; do
    read -p "[*] Please plug a permanent ethernet dongle to the usb 3.0 port [Enter] "
    eth1mac=$(ifconfig -a | grep eth1 | egrep -o '.{2}:.{2}:.{2}:.{2}:.{2}:.{2}')
done
echo "[*] Obtained ethernet mac addresses:"
echo "  eth0: ${eth0mac}"
echo "  eth1: ${eth1mac} (USB 3.0 gigabit internet)"
echo
sleep 1

echo "[*] Now writing to 70-persistent-net.rules.. "
sleep 1
touch /etc/udev/rules.d/70-persistent-net.rules
cat /dev/null > /etc/udev/rules.d/70-persistent-net.rules
cat 70-persistent-net.rules | while read -r line; do
    if [[ ${line} == *'NAME="eth0"'* ]]; then
        contentLine="${line/0a:0a:0a:0a:0a:0a/$eth0mac}";
    elif [[ ${line} == *'NAME="eth1"'* ]]; then
        contentLine="${line/0a:0a:0a:0a:0a:0a/$eth1mac}";
    fi
    echo ${contentLine} >> /etc/udev/rules.d/70-persistent-net.rules
    #echo ${contentLine}
done
echo '---- /etc/udev/rules.d/70-persistent-net.rules ----'
cat /etc/udev/rules.d/70-persistent-net.rules
echo '---------------------------------------------------'

echo "[*] Writing to eth0 and eth1.. "
sleep 1
sudo touch /etc/network/interfaces.d/eth0
sudo touch /etc/network/interfaces.d/eth1
cat xu3/eth0 | sudo tee /etc/network/interfaces.d/eth0 > /dev/null
cat xu3/eth1 | sudo tee /etc/network/interfaces.d/eth1 > /dev/null

echo '---- /etc/network/interfaces.d/eth0 ----'
cat /etc/network/interfaces.d/eth0
echo '---- /etc/network/interfaces.d/eth1 ----'
cat /etc/network/interfaces.d/eth1
echo '----------------------------------------'

read -p "[*] This node will now shutdown. Then do this: Connect ethernet cable to the USB dongle, then turn the node back on [Enter] "
shutdown -h now
