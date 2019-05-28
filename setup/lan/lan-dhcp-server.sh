#!/bin/bash
# Proper header for a Bash script.
# Ref http://diybigdata.net/2017/11/upgrading-odroid-cluster-to-ubuntu-16-04/
# Login as 'odroid' user
if [[ $(hostname) != 'master' ]]; then echo "Please run this on 'master' node only"; exit 1; fi
if [[ $(whoami) != 'odroid' ]]; then echo "Please run as 'odroid' user"; exit 1; fi

# Fix perl complaining error of some missing locales. See https://gist.github.com/panchicore/1269109
sudo locale-gen en_US.UTF-8

# Disable Network Manager
echo "[*] Disabling NetworkManager.service.. "
sudo systemctl disable NetworkManager.service

# Edit 70-rules to clearly distinguish eth0 and eth1
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
echo "  eth0: ${eth0mac} (gigabit internet)"
echo "  eth1: ${eth1mac} (USB 3.0 gigabit internet)"
echo
sleep 1

echo "[*] Now writing to 70-persistent-net.rules.. "
sleep 1
sudo touch /etc/udev/rules.d/70-persistent-net.rules
cat /dev/null | sudo tee /etc/udev/rules.d/70-persistent-net.rules > /dev/null
cat 70-persistent-net.rules | while read -r line; do
    if [[ ${line} == *'NAME="eth0"'* ]]; then
        contentLine="${line/0a:0a:0a:0a:0a:0a/$eth0mac}";
    elif [[ ${line} == *'NAME="eth1"'* ]]; then
        contentLine="${line/0a:0a:0a:0a:0a:0a/$eth1mac}";
    fi
    echo ${contentLine} | sudo tee --append /etc/udev/rules.d/70-persistent-net.rules > /dev/null
    #echo ${contentLine}
done
echo '---- /etc/udev/rules.d/70-persistent-net.rules ----'
cat /etc/udev/rules.d/70-persistent-net.rules
echo '---------------------------------------------------'

# Define functionality of eth0 and eth1
echo "[*] Writing to /etc/network/interfaces.d/eth0 & /etc/network/interfaces.d/eth1.. "
sudo touch /etc/network/interfaces.d/eth0
sudo touch /etc/network/interfaces.d/eth1
cat master-eth0 | sudo tee /etc/network/interfaces.d/eth0 > /dev/null
cat master-eth1 | sudo tee /etc/network/interfaces.d/eth1 > /dev/null

echo '---- /etc/network/interfaces.d/eth0 ----'
cat /etc/network/interfaces.d/eth0
echo '---- /etc/network/interfaces.d/eth1 ----'
cat /etc/network/interfaces.d/eth1
echo '----------------------------------------'
sleep 1


# Start setting up DHCP and NAT
echo "[*] Installing iptables.. "
sudo apt-get install iptables

# Modifying sysctl.conf
echo "[*] Enabling ipv4.ip_forward in sysctl.conf.. "
sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
echo '---- /etc/sysctl.conf ----'
grep -C 2 'net.ipv4.ip_forward=1' /etc/sysctl.conf
echo '--------------------------'
echo
sleep 1

# Modifying rc.local
echo "[*] Writing to rc.local.."
sleep 1
line1='/sbin/iptables -P FORWARD ACCEPT'
line2='/sbin/iptables --table nat -A POSTROUTING -o eth1 -j MASQUERADE'
# check line 1
cnt=$(grep "$line1" /etc/rc.local | wc -l)
if [[ ${cnt} -eq 0 ]]; then
    text=${line1//\//\\/}
    sudo sed -i "s/exit 0/$text\nexit 0/g" /etc/rc.local
fi
# check line 2
cnt=$(grep "$line2" /etc/rc.local | wc -l)
if [[ ${cnt} -eq 0 ]]; then
    text=${line2//\//\\/}
    sudo sed -i "s/exit 0/$text\nexit 0/g" /etc/rc.local
fi
echo '---- /etc/rc.local ----'
grep -C 4 'exit 0' /etc/rc.local
echo '-----------------------'
echo

# DHCP installation
echo "[*] Installing DHCP server.. "
sleep 1
sudo apt-get install isc-dhcp-server -y

# DHCP installation config change
echo "[*] Now modifying isc-dhcp-server.. "
sleep 1
cnt=$(grep 'INTERFACES=""' /etc/default/isc-dhcp-server | wc -l)
if [[ ${cnt} -eq 1 ]]; then
    sudo sed -i 's/INTERFACES=""/INTERFACES="eth0"/g' /etc/default/isc-dhcp-server
fi
echo '---- /etc/default/isc-dhcp-server ----'
grep -C 4 'INTERFACES=' /etc/default/isc-dhcp-server
echo '--------------------------------------'
echo

# DHCP modify LAN machines config
echo "[*] Now modifying dhcpd.conf.. "
sleep 1
line1='option domain-name-servers ns1.example.org'
line2='option domain-name "example.org";'
line3='authoritative;'
# check line 1
cnt=$(grep "#${line1}" /etc/dhcp/dhcpd.conf | wc -l)
if [[ ${cnt} -eq 0 ]]; then
    sudo sed -i "s/$line1/#$line1/g" /etc/dhcp/dhcpd.conf
fi
# check line 2
cnt=$(grep "#${line2}" /etc/dhcp/dhcpd.conf | wc -l)
if [[ ${cnt} -eq 0 ]]; then
    sudo sed -i "s/$line2/#$line2/g" /etc/dhcp/dhcpd.conf
fi
# check line 3
cnt=$(grep "#${line3}" /etc/dhcp/dhcpd.conf | wc -l)
if [[ ${cnt} -eq 1 ]]; then
    sudo sed -i "s/#$line3/$line3/g" /etc/dhcp/dhcpd.conf
fi
echo '---- /etc/dhcp/dhcpd.conf ----'
grep -C 1 "$line1" /etc/dhcp/dhcpd.conf
echo '....'
grep -C 1 "$line2" /etc/dhcp/dhcpd.conf
echo '....'
grep -C 1 "$line3" /etc/dhcp/dhcpd.conf
echo '------------------------------'
echo

# DHCP config change: append this block to end of file
line=$(head -1 master-dhcpd.conf)
res=$(grep "$line" /etc/dhcp/dhcpd.conf)
if [[ -z ${res} ]]; then
    echo "[*] Appending to dhcpd.conf.. "
    sleep 1
    cat master-dhcpd.conf | sudo tee --append /etc/dhcp/dhcpd.conf > /dev/null
fi
read -p "[*] Please edit dhcpd.conf and correct each slave's MAC address accordingly [Enter] "
sudo nano /etc/dhcp/dhcpd.conf

# Done
read -p "[*] DONE [Enter] "

