#!/bin/bash
# Proper header for a Bash script.
# Ref http://diybigdata.net/2016/07/installing-spark-onto-odroid-xu4-cluster/
if [ $(whoami) != 'odroid' ]; then echo "Please run as 'odroid' user"; exit 1; fi

# Fix perl complaining error of some missing locales. See https://gist.github.com/panchicore/1269109
sudo locale-gen en_US.UTF-8

read -p "[*] Create /home/hduser/spark for containing spark data [Enter] "
sudo mkdir -p /home/hduser/spark
sudo chown hduser:hadoop /home/hduser/spark

read -p "[*] Install python3 [Enter] "
sudo apt-get install python3

read -p "[*] Install spark software under /opt/ [Enter] "
sudo wget http://diybigdata.net/downloads/spark/spark-2.1.0-bin-hadoop2.7-double-alignment.tgz -P $HOME/
sudo tar xvzf $HOME/spark-2.1.0-bin-hadoop2.7-double-alignment.tgz -C /opt/
sudo chown -R hduser:hadoop /opt/spark-2.1.0-bin-v2.1.0-double-alignment
sudo ln -s -f /opt/spark-2.1.0-bin-v2.1.0-double-alignment /usr/local/spark

read -p "[*] Config spark [Enter] "
sudo cp -f /usr/local/spark/conf/spark-env.sh.template /usr/local/spark/conf/spark-env.sh
cat spark-env.sh.partial | sudo tee --append /usr/local/spark/conf/spark-env.sh > /dev/null
sudo cp -f /usr/local/spark/conf/spark-defaults.conf.template /usr/local/spark/conf/spark-defaults.conf
cat spark-defaults.conf.partial | sudo tee --append /usr/local/spark/conf/spark-defaults.conf > /dev/null
sudo cp -f /usr/local/spark/conf/slaves.template /usr/local/spark/conf/slaves
cat slaves.partial | sudo tee --append /usr/local/spark/conf/slaves > /dev/null

# Done
read -p "[*] Done [Enter] "
exit 0

