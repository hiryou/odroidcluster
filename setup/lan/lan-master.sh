#!/bin/bash
# Proper header for a Bash script.
# Ref http://diybigdata.net/2017/11/upgrading-odroid-cluster-to-ubuntu-16-04/
# Turn on the whole cluster; Login to master as 'odroid' user
if [ $(hostname) != 'master' ]; then echo "Please run this on 'master' node only"; exit 1; fi
if [ $(whoami) != 'odroid' ]; then echo "Please run as 'odroid' user"; exit 1; fi

# Fix perl complaining error of some missing locales. See https://gist.github.com/panchicore/1269109
sudo locale-gen en_US.UTF-8

read -p "[*] Please restart/turn on the whole cluster [Enter] "
read -p "[*] Confirm whole cluster was on? [Enter] "

for slave in `cat cluster-slaves.txt`; do 
	read -p "[*] Test ping $slave [Enter] "
	timeout 4 ping $slave; 
done

read -p "[*] Install distributed SSH [Enter] "
sudo apt-get install pssh

read -p "[*] Create cluster manifest: all.txt, slaves.txt [Enter] "
mkdir -p ~/cluster
cat cluster-all.txt > ~/cluster/all.txt
cat cluster-slaves.txt > ~/cluster/slaves.txt

if [ ! -f ~/.ssh/id_rsa ] || [ ! -f ~/.ssh/id_rsa.pub ]; then 
	read -p "[*] Creating no-password SSH key..."
	ssh-keygen -t rsa -P ""
fi
read -p "[*] Establishing trusted host and distributing single SSH key [Enter] "
for host in `cat cluster-all.txt`; do 
	# copy single ssh key to all nodes
	ssh-copy-id root@$host
	ssh-copy-id odroid@$host
	# login to establish trusted host
	ssh root@$host exit
	ssh odroid@$host exit
done
# Add all slaves as trusted hosts with master
#for slave in `cat cluster-slaves.txt`; do ssh-keygen -f "$HOME/.ssh/known_hosts" -R $slave done

while true; do
    read -p "[*] Append useful commands to .bashrc? [y/n] " yn
    case $yn in
        [Yy]* ) 
        	cat bashrc.partial >> $HOME/.bashrc
			source ~/.bashrc 
        	break;;
        [Nn]* ) break;;
        * ) ;;
    esac
done

# Done
read -p "[*] DONE [Enter] "

