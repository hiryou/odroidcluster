#!/bin/bash
# Proper header for a Bash script.
# Ref http://diybigdata.net/2017/11/upgrading-odroid-cluster-to-ubuntu-16-04/
# Turn on the whole cluster; Login to master as 'odroid' user
if [[ $(hostname) != 'master' ]]; then echo "Please run this on 'master' node only"; exit 1; fi
if [[ $(whoami) != 'odroid' ]]; then echo "Please run as 'odroid' user"; exit 1; fi

# Fix perl complaining error of some missing locales. See https://gist.github.com/panchicore/1269109
sudo locale-gen en_US.UTF-8

read -p "[*] Confirm whole cluster was on? And you're running master node? [Enter] "

for slave in `cat cluster-slaves.txt`; do
	echo "[*] Pinging $slave .. "
	timeout 4 ping ${slave};
done

echo "[*] Installing distributed SSH.. "
sleep 1
sudo apt-get install pssh

echo "[*] Creating cluster manifest: all.txt, slaves.txt [Enter] "
mkdir -p ~/cluster
cat cluster-all.txt > ~/cluster/all.txt
cat cluster-slaves.txt > ~/cluster/slaves.txt

if [[ ! -f ~/.ssh/id_rsa ]] || [[ ! -f ~/.ssh/id_rsa.pub ]]; then
	echo "[*] Creating no-password SSH key..."
	ssh-keygen -t rsa -P ""
fi
read -p "[*] Establishing trusted host and distributing single SSH key [Enter] "
for host in `cat cluster-all.txt`; do
	# copy single ssh key to all nodes
	ssh-copy-id root@${host}
	ssh-copy-id odroid@${host}
	# login to establish trusted host
	ssh root@${host} exit
	ssh odroid@${host} exit
	echo "  Connected & trusted: $host"
done
# Add all slaves as trusted hosts with master
for slave in `cat cluster-slaves.txt`; do ssh-keygen -f "$HOME/.ssh/known_hosts" -R ${slave} done

line=$(head -1 bashrc.partial)
res=$(grep "$line" $HOME/.bashrc)
if [[ -z ${res} ]]; then
    echo "[*] Appending useful commands to .bashrc .. "
    cat bashrc.partial >> $HOME/.bashrc
    source ~/.bashrc
fi

# Done
read -p "[*] DONE [Enter] "
