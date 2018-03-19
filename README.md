# Odroid Distributed System

Project odroid cluster (xu3lite and xu4) as headless distributed system
- LAN network & IP addr assigment
- hadoop/spark cluster
- more to come..

## Prerequisites
- Each Odroid board is preloaded with ubuntu 16.04 (as of this writing)
- Each Odroid turns on successfully with default username/password = root/odroid

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

Initial setup for all nodes
```
cd ./setup/lan
chmod +x *.sh
./setup-1.sh
# Follow instructions
# Once this setup is done for all nodes, the whole cluster should have been shutdown
```
Now turn on the whole cluster and ssh to master node
```
cd ./setup/lan
./setup-2.sh
```

### 2. Setup hadoop

Go to each node to run the setup scripts
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

