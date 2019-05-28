#!/bin/bash
# Proper header for a Bash script.
# Ref 	http://diybigdata.net/2017/11/upgrading-odroid-cluster-to-ubuntu-16-04/
#		http://diybigdata.net/2016/07/running-the-word-count-job-with-hadoop/
if [[ $(whoami) != 'hduser' ]]; then echo "Please run as 'hduser' user"; exit 1; fi
if [[ $(hostname) != 'master' ]]; then echo "Please run this on 'master' node only"; exit 1; fi

# Fix perl complaining error of some missing locales. See https://gist.github.com/panchicore/1269109
sudo locale-gen en_US.UTF-8

if [[ ! -f ~/.ssh/id_rsa ]] || [[ ! -f ~/.ssh/id_rsa.pub ]]; then
	read -p "[*] Generating ssh key [Enter] "
	ssh-keygen -t rsa -P ""
fi
read -p "[*] Establishing trusted host and distributing single SSH key [Enter] "
# for master
#cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys
#ssh hduser@localhost exit
# Add all slaves as trusted hosts with master
#for slave in `cat hadoop-conf/slaves`; do ssh-keygen -f "$HOME/.ssh/known_hosts" -R $slave done
# for master and all slaves
for host in `cat hadoop-conf/slaves`; do 
	ssh-copy-id hduser@$host
	ssh hduser@$host exit
done


while true; do
    read -p "[*] Format namenode? [y/n] " yn
    case $yn in
        [Yy]* ) 
        	sudo -H -u hduser bash -c 'hdfs namenode -format' 
        	break;;
        [Nn]* ) break;;
        * ) ;;
    esac
done

# DONE
read -p "[*] Done. Press any key to exit [Enter] "
exit 0
