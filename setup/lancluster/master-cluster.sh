#!/bin/bash
# Proper header for a Bash script.
# Ref http://diybigdata.net/2017/11/upgrading-odroid-cluster-to-ubuntu-16-04/
# Turn on the whole cluster; Login to master as 'odroid' user

read -p "[*] Test ping slave1..."
ping slave1
read -p "[*] Test ping slave2..."
ping slave2
read -p "[*] Test ping slave3..."
ping slave3
read -p "[*] Test ping slave4..."
ping slave4

read -p "[*] Installing distributed SSH..."
sudo apt-get install pssh

read -p "[*] Creating cluster manifest: all.txt, slaves.txt ..."
mkdir -p ~/cluster
cat cluster-all.txt > ~/cluster/all.txt
cat cluster-slaves.txt > ~/cluster/slaves.txt

if [ ! -f ~/.ssh/id_rsa ] || [ ! -f ~/.ssh/id_rsa.pub ]; then 
	read -p "[*] Creating SSH key..."
	ssh-keygen -t rsa -P ""
fi
read -p "[*] Distributing single SSH key..."
# As user 'root'
ssh-copy-id root@master
ssh-copy-id root@slave1
ssh-copy-id root@slave2
ssh-copy-id root@slave3
ssh-copy-id root@slave4
# As user 'odroid'
ssh-copy-id odroid@master
ssh-copy-id odroid@slave1
ssh-copy-id odroid@slave2
ssh-copy-id odroid@slave3
ssh-copy-id odroid@slave4

# Done
read -p "[*] Done. Now you can do: 'shutdown -h now'"

