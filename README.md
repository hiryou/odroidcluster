# Odroid Distributed System

Project odroid cluster (xu3lite and xu4) as headless distributed system
- LAN network & IP addr assigment
- hadoop/spark cluster
- more to come..

## Prerequisites
- Each Odroid board is preloaded with ubuntu 16.04 (as of this writing)
- Each Odroid turns on successfully with default username/password = root/odroid

## Setup Cluster

- This instruction will guide you through setting up LAN network then hadoop
- The order of setup is: slave1, slave2, .., slavex, master. Master node is setup at the end.

### Setup LAN network

scp ./setup to all nodes, then go to each node to run the setup scripts
```
cd ./setup/lancluster
chmod +x *.sh
./setup-1.sh
# Follow instructions
# Once this setup is done for all nodes, the whole cluster should have been shutdown
```
Now turn on the whole cluster and ssh to master node
```
cd ./setup/lancluster
./setup-2.sh
```

### Setup hadoop cluster

Go to each node to run the setup scripts
```
cd ./setup/hadoopcluster
chmod +x *.sh
./setup.sh
# Follow instructions
```

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

