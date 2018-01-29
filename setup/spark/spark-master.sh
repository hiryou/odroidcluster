#!/bin/bash
# Proper header for a Bash script.
# Ref http://diybigdata.net/2016/07/installing-spark-onto-odroid-xu4-cluster/
if [ $(hostname) != 'master' ]; then echo "Please run this on 'master' node only"; exit 1; fi
if [ $(whoami) != 'hduser' ]; then echo "Please run as 'hduser' user"; exit 1; fi

# Fix perl complaining error of some missing locales. See https://gist.github.com/panchicore/1269109
sudo locale-gen en_US.UTF-8

read -p "[*] Create data  folder for jupyter notebooks [Enter] "
sudo mkdir -p /home/hduser/jupyter
sudo chown -R hduser:hadoop /home/hduser/jupyter
mkdir $HOME/notebooks

while true; do
    read -p "[*] Append useful commands to .bashrc? [Enter] " yn
    case $yn in
        [Yy]* ) 
        	cat bashrc.partial >> $HOME/.bashrc
			source ~/.bashrc 
        	break;;
        [Nn]* ) break;;
        * ) ;;
    esac
done

read -p "[*] Install jupyter [Enter] "
sudo apt-get install python3-pip
sudo -H pip3 install --upgrade pip
sudo pip3 install jupyter

read -p "[*] Install matplotlib [Enter] "
sudo apt-get build-dep matplotlib
sudo pip3 install matplotlib

#read -p "[*] Create log folder for pyspark: /var/log/pyspark [Enter] "
#sudo mkdir -p /var/log/pyspark
#sudo chown -R hduser:hadoop /var/log/pyspark


# Done
read -p "[*] Done [Enter] "
exit 0

