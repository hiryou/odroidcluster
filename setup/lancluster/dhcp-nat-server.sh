#!/bin/bash
# Proper header for a Bash script.
# Ref http://diybigdata.net/2017/11/upgrading-odroid-cluster-to-ubuntu-16-04/
# Login as 'odroid' user to 

# Disable Network Manager
read -p "[*] Disabling NetworkManager.service..."
sudo systemctl disable NetworkManager.service

# Edit 70-rules to clearly distinguish eth0 and eth1
read -p "[*] Have MAC addr of eth0 and eth1 ready before continue..."
sudo touch /etc/udev/rules.d/70-persistent-net.rules
cat 70-persistent-net.rules | sudo tee /etc/udev/rules.d/70-persistent-net.rules > /dev/null
sudo nano /etc/udev/rules.d/70-persistent-net.rules

# Define functionality of eth0 and eth1
read -p "[*] Writing to /etc/network/interfaces.d/eth0 & /etc/network/interfaces.d/eth1..."
sudo touch /etc/network/interfaces.d/eth0
sudo touch /etc/network/interfaces.d/eth1
cat master-eth0 | sudo tee /etc/network/interfaces.d/eth0 > /dev/null
cat master-eth1 | sudo tee /etc/network/interfaces.d/eth1 > /dev/null


# Start setting up DHCP and NAT
read -p "[*] Installing iptables..."
sudo apt-get install iptables

# Modifying sysctl.conf
read -p "[*] Now modifying sysctl.conf. Look for this line and uncomment it: `echo $'\n '`net.ipv4.ip_forward=1 `echo $'\n '`"
sudo nano /etc/sysctl.conf

# Modifying rc.local
read -p "[*] Now modifying rc.local. Put these lines before 'exit 0': `echo $'\n '`/sbin/iptables -P FORWARD ACCEPT `echo $'\n '`/sbin/iptables --table nat -A POSTROUTING -o eth1 -j MASQUERADE `echo $'\n '`"
sudo nano /etc/rc.local

# DHCP installation
read -p "[*] Installing DHCP server..."
sudo apt-get install isc-dhcp-server -y

# DHCP installation config change
read -p "[*] Now modifying isc-dhcp-server. Look for this line 'INTERFACES=\"\"' and change it to 'INTERFACES=\"eth0\"'..."
sudo nano /etc/default/isc-dhcp-server

# DHCP modify LAN machines config
read -p "[*] Modifying dhcpd.conf. Comment out these lines: `echo $'\n '`  #option domain-name \"example.org\"; `echo $'\n '`  #option domain-name-servers ns1.example.org, ns2.example.org; `echo $'\n '`And uncomment this line: `echo $'\n '`  authoritative; `echo $'\n '`"
sudo nano /etc/dhcp/dhcpd.conf

# DHCP config change: append this block to end of file
read -p "[*] Appending host config to dhcpd.conf..."
cat master-dhcpd.conf | sudo tee --append /etc/dhcp/dhcpd.conf > /dev/null

# Done
read -p "[*] Done. Now you can do: 'shutdown -h now'"

