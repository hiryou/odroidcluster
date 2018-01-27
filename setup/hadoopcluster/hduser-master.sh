#!/bin/bash
# Proper header for a Bash script.
# Ref 	http://diybigdata.net/2017/11/upgrading-odroid-cluster-to-ubuntu-16-04/
#		http://diybigdata.net/2016/07/running-the-word-count-job-with-hadoop/
if [ $(whoami) != 'hduser' ]; then echo "Please run as 'hduser' user"; exit 1; fi
if [ $(hostname) != 'master' ]; then echo "Please run this on 'master' node only"; exit 1; fi

# Fix perl complaining error of some missing locales. See https://gist.github.com/panchicore/1269109
sudo locale-gen en_US.UTF-8

read -p "[*] Creating and distributing ssh key..."
ssh-keygen -t rsa -P ""
# for master
cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys
ssh hduser@localhost exit
# and all slaves
ssh-copy-id hduser@slave1
ssh-copy-id hduser@slave2
ssh-copy-id hduser@slave3
ssh-copy-id hduser@slave4
ssh hduser@slave1 exit
ssh hduser@slave2 exit
ssh hduser@slave3 exit
ssh hduser@slave4 exit

read -p "[*] Formatting namenode..."
hdfs namenode -format

# DONE
read -p "[*] Done. Press any key to exit..."
exit 0

