#!/bin/bash
# Proper header for a Bash script.
# Ref 	http://diybigdata.net/2016/06/installing-hadoop-onto-an-odroid-xu4-cluster/#starting-hdfs
if [ $(whoami) != 'odroid' ]; then echo "Please run as 'odroid' user"; exit 1; fi

# Fix perl complaining error of some missing locales. See https://gist.github.com/panchicore/1269109
sudo locale-gen en_US.UTF-8

# Install java 8
# Source https://www.digitalocean.com/community/tutorials/how-to-install-java-with-apt-get-on-ubuntu-16-04
java -version
if [ $? -ne 0 ]; then 
	read -p "[*] Installing JDK 8 now [Enter] "
	sudo add-apt-repository ppa:webupd8team/java
	sudo apt-get update
	sudo apt-get install oracle-java8-installer
fi

# Create hadoop user/group
id -u hadoop &>/dev/null || {
	read -p "[*] Adding group:hadoop, user:hduser (password:hduser) [Enter] "
	sudo addgroup hadoop
	sudo adduser --ingroup hadoop hduser
	sudo adduser hduser sudo
	sudo usermod -aG sudo hduser
}

# Done
read -p "[*] Done [Enter] "
exit 0

