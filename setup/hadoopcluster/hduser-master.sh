#!/bin/bash
# Proper header for a Bash script.
# Ref 	http://diybigdata.net/2017/11/upgrading-odroid-cluster-to-ubuntu-16-04/
#		http://diybigdata.net/2016/07/running-the-word-count-job-with-hadoop/
if [ $(whoami) != 'hduser' ]; then echo "Please run as 'hduser' user"; exit 1; fi
if [ $(hostname) != 'master' ]; then echo "Please run this on 'master' node only"; exit 1; fi

# Fix perl complaining error of some missing locales. See https://gist.github.com/panchicore/1269109
sudo locale-gen en_US.UTF-8

if [ ! -f ~/.ssh/id_rsa ] || [ ! -f ~/.ssh/id_rsa.pub ]; then 
	read -p "[*] Generating ssh key [Enter] "
	ssh-keygen -t rsa -P ""
fi
read -p "[*] Distributing ssh key [Enter] "
# for master
#cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys
#ssh hduser@localhost exit
# for master and all slaves
ssh-copy-id hduser@master
ssh-copy-id hduser@slave1
ssh-copy-id hduser@slave2
ssh-copy-id hduser@slave3
ssh-copy-id hduser@slave4
ssh hduser@localhost exit
ssh hduser@master exit
ssh hduser@slave1 exit
ssh hduser@slave2 exit
ssh hduser@slave3 exit
ssh hduser@slave4 exit

read -p "[*] Formatting namenode [Enter] "
sudo -H -u hduser bash -c 'hdfs namenode -format' 

# DONE
read -p "[*] Done. Press any key to exit [Enter] "
exit 0

