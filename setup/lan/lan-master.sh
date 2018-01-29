#!/bin/bash
# Proper header for a Bash script.
# Ref http://diybigdata.net/2017/11/upgrading-odroid-cluster-to-ubuntu-16-04/
# Turn on the whole cluster; Login to master as 'odroid' user
if [ $(hostname) != 'master' ]; then echo "Please run this on 'master' node only"; exit 1; fi
if [ $(whoami) != 'odroid' ]; then echo "Please run as 'odroid' user"; exit 1; fi

# Fix perl complaining error of some missing locales. See https://gist.github.com/panchicore/1269109
sudo locale-gen en_US.UTF-8

read -p "[*] Please turn on the whole cluster [Enter] "
read -p "[*] Confirm whole cluster was on? [Enter] "

read -p "[*] Test ping slave1 [Enter] "
ping slave1
read -p "[*] Test ping slave2 [Enter] "
ping slave2
read -p "[*] Test ping slave3 [Enter] "
ping slave3
read -p "[*] Test ping slave4 [Enter] "
ping slave4

read -p "[*] Install distributed SSH [Enter] "
sudo apt-get install pssh

read -p "[*] Create cluster manifest: all.txt, slaves.txt [Enter] "
mkdir -p ~/cluster
cat cluster-all.txt > ~/cluster/all.txt
cat cluster-slaves.txt > ~/cluster/slaves.txt

if [ ! -f ~/.ssh/id_rsa ] || [ ! -f ~/.ssh/id_rsa.pub ]; then 
	read -p "[*] Creating SSH key..."
	ssh-keygen -t rsa -P ""
fi
read -p "[*] Distributing single SSH key [Enter] "
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

read -p "[*] Appending useful commands to .bashrc [Enter] "
cat bashrc.partial >> $HOME/.bashrc
source ~/.bashrc 

# Done
read -p "[*] DONE [Enter] "

