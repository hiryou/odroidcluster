#!/bin/bash
# Proper header for a Bash script.
# Ref http://diybigdata.net/2017/11/upgrading-odroid-cluster-to-ubuntu-16-04/
if [[ $(whoami) != 'hduser' ]]; then echo "Please run as 'hduser' user"; exit 1; fi

# Dir of this executing script
#DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Fix perl complaining error of some missing locales. See https://gist.github.com/panchicore/1269109
sudo locale-gen en_US.UTF-8

# Create hadoop hdfs storage folder
read -p "[*] Creating $HOME/hdfs for hadoop file system storage [Enter] "
mkdir -p $HOME/hdfs/tmp
chown -R hduser:hadoop $HOME/hdfs

# Exact hadoop artifact with pre-configuration to /opt & setup hadoop
read -p "[*] Manually download arm-built hadoop from http://diybigdata.net/?smd_process_download=1&download_id=110. Put it in /home/hduser [Enter] "
read -p "[*] Confirm download is done? Extracting hadoop software to /opt/ [Enter] "
sudo tar xf /home/hduser/hadoop-2.7.2.armhf.tar.gz -C /opt/
sudo chown -R hduser:hadoop /opt/hadoop-2.7.2
sudo ln -s -f /opt/hadoop-2.7.2 /usr/local/hadoop

read -p "[*] Setting pre-determined configs for hadoop [Enter] "
sudo cp -f hadoop-conf/hadoop-env.sh /opt/hadoop-2.7.2/etc/hadoop/
sudo cp -f hadoop-conf/core-site.xml /opt/hadoop-2.7.2/etc/hadoop/
sudo cp -f hadoop-conf/hdfs-site.xml /opt/hadoop-2.7.2/etc/hadoop/
sudo cp -f hadoop-conf/mapred-site.xml /opt/hadoop-2.7.2/etc/hadoop/
sudo cp -f hadoop-conf/yarn-site.xml /opt/hadoop-2.7.2/etc/hadoop/
# configs for masters and slaves
sudo cp -f hadoop-conf/masters /opt/hadoop-2.7.2/etc/hadoop/
sudo cp -f hadoop-conf/slaves /opt/hadoop-2.7.2/etc/hadoop/

read -p "[*] Appending content to .bashrc [Enter] "
cat bashrc.partial >> $HOME/.bashrc
source ~/.bashrc 

read -p "[*] Verify that Hadoop’s environment is set up [Enter] "
#hadoop version
sudo runuser -l hduser -c "hadoop version"

# DONE
read -p "[*] Done. Press any key to exit [Enter] "
exit 0
