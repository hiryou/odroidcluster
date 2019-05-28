# Odroid Distributed System

Project odroid cluster (xu3lite and xu4) as headless distributed system
- LAN network & IP addr assigment
- hadoop/spark cluster
- more to come..

## Install ubuntu 16.04
Download img.xz from [here](https://odroid.in/ubuntu_16.04lts/). Use minimal for headless server

Obtain list of current mounting devices
```bash
diskutil list
```

Uncompress xz to img
```bash
$ xz -d /path/to/ubuntu-image.xz
# this will generate ubuntu-image.img
```

Plug eMMC module to eMMC reader, then eMMC reader to SSD card reader -> computer
diskutil check again to obtain the correct path to eMMC module
```bash
diskutil list
```

Now unmount eMMC path, and flash it
```bash
diskutil unmountdisk /dev/diskX
sudo dd of=/dev/diskX bs=1m if=/path/to/ubuntu-image.img
# waiting..
```

Once done, remember to unmount it
```bash
diskutil unmountdisk /dev/diskX
```

Now you can plug it to the droid

## Setup Cluster

- This instruction will guide you through setting up LAN network, hadoop, spark with jupyter notebook
- The order of setup is: slave1, slave2, .., slavex, master. Master node is setup at the end.
- scp/rsync ./setup to all nodes, then go to each node to run the setup scripts

### 0. Odroid xu3/xu3-lite

These boards default ethernet interface (eth0) is not gigabit. To make gigabit ethernet possible, we attach a gigabit ethernet dongle (eth1) to the board's usb 3.0 port. Run this setup to activate eth1 as primary ethernet interface for the board.
```
cd ./setup/lancluster
chmod +x *.sh
./setup-odroid-xu3.sh
# Follow instructions
```

### 1. Setup LAN network

Initial setup for each node, one at a time. Do all slave nodes first, then master node:
```
cd ./setup/lan
./setup-node.sh
# Follow instructions
# Once this setup is done, all nodes should have been shutdown
```
Now turn on the whole cluster and ssh to master node (connected through USB 3.0 ethernet dongle)
```
cd ./setup/lan
./setup-master.sh
```

### 2. Setup hadoop

Go to each node to run the setup scripts. Do all slave nodes first, then master node:
```
cd ./setup/hadoop
chmod +x *.sh
./setup.sh
# Follow instructions
```

### 3. Setup spark

Go to each node to run the setup scripts
```
cd ./setup/spark
chmod +x *.sh
./setup.sh
# Follow instructions
```

## Add/Update a slave node

- Go through the whole Setup Cluster section for the node. Once done, attach the node to the LAN network managed by master node.
- Restart master node
- ssh to master and run these 2 scripts
```
su - odroid
./setup/lan/lan-master.sh
su - hduser
./setup/hadoop/hadoop-master.sh
```

## Useful commands from master node

As user 'odroid'
```
cluster-ping		# Test ping all machines in cluster
cluster-restart		# Restart whole cluster
cluster-shutdown 	# Shutdown whole cluster

```

As user 'hduser'
```
hadoop-start	# Start hdfs and yarn
hadoop-stop		# Stop yarn and hdfs
hadoop-jps		# Just 'jps'

spark-start				# Start hdfs and spark
spark-stop				# Stop spark and hdfs

spark-jupyter-start		# Start jupyter notebook interatively at http://master:7777
spark-jupyter-stop		# Stop jupyter notebook running at http://master:7777

cluster-sync-hadoopconfigs		# Sync hadoop configs from master to all slaves
cluster-sync-sparkconfigs		# Sync spark configs from master to all slaves
```

## Benchmarks
* [TODO] Checkout hadoop default benchmark suites
* [Recommended] terasort 10Gb - 100Gb  

## Sample hadoop job run

## Sample spark job run

## Authors

* **Hiryou** - *Main author* - [Hiryou](https://github.com/hiryou)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Whatever...
* Inspiration
* etc

