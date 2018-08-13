# kafka

This repository provides everything you need to run Apache Kafka in Swarm.

It needs zookeeper cluster located in the same overlay network. See docker compose examples

Environment Variables
-----

 * `TOPIC_LIST` - Comma separated List of topics to be created if not exists [Topic name]:[REPLICATION Factor]:[Number Of Partitions]
 * `ZK_HOSTS` - Comma separated list of Zookeeper servers hosts ans ports. For Example "zoo1:2181,zoo2:2181,zoo3:2181"
 * `ZK_CHROOT` - Path for Zookeeper directory
 * `AUTO_GEN_BROKER_ID` - set to true if you woul like to scale kafka service using.
 * `AUTO_CREATE_TOPICS` - sets auto.create.topics.enable property to true.
 * `LOG_RETENTION_HOURS` - The number of hours to keep a log file before deleting it (in hours). Default 160
 * `LOG_RETENTION_BYTES` - The maximum size of the log before deleting it. Default -1.
 * `NUM_PARTTIONS` - The default number of log partitions per topic.
 
 
Docker Compose Examples
-------------------------

**Running cluster of single ZK instance and single Kafka instance with two topics**
* topic1  - Replication Factor 1 and Number of Partitions 5
* topic2  - Replication Factor 1 and Number of Partitions 4
  
```yaml

version: '3.6'
services:
  zoo1:
    hostname: zoo1
    image: zookeeper
    ports:
    - 2181
    environment:
      ZOO_MY_ID: 1
      ZOO_SERVERS: server.1=0.0.0.0:2888:3888
    networks:
    - net

  kafka:
    hostname: kafka
    image: dannylesnik/kafka
    ports:
    - 9092
    environment:
      ZK_HOSTS: "zoo1:2181"
      TOPIC_LIST: "topic1:1:5,topic2:1:4"
      AUTO_GEN_BROKER_ID: "true"
      ZK_CHROOT: "bla"
    networks:
    - net

networks:
  net:

```

**Running cluster of 3 ZK instances and Kafka of 4 instance with two topics**
* topic1  - Replication Factor 1 and Number of Partitions 5
* topic2  - Replication Factor 3 and Number of Partitions 4

```yaml
version: '3.6'
services:
  zoo1:
    hostname: zoo1
    image: zookeeper
    ports:
    - 2181
    environment:
      ZOO_MY_ID: 1
      ZOO_SERVERS: server.1=0.0.0.0:2888:3888 server.2=zoo2:2888:3888 server.3=zoo3:2888:3888
    networks:
    - net

  zoo2:
    hostname: zoo2
    image: zookeeper
    ports:
    - 2181
    environment:
      ZOO_MY_ID: 2
      ZOO_SERVERS: server.1=zoo1:2888:3888 server.2=0.0.0.0:2888:3888 server.3=zoo3:2888:3888
    networks:
    - net

  zoo3:
    hostname: zoo3
    image: zookeeper
    ports:
    - 2181
    environment:
      ZOO_MY_ID: 3
      ZOO_SERVERS: server.1=zoo1:2888:3888 server.2=zoo2:2888:3888 server.3=0.0.0.0:2888:3888
    networks:
    - net

  kafka:
    hostname: kafka
    image: dannylesnik/kafka
    ports:
    - 9092
    deploy:
      replicas: 4
    environment:
      ZK_HOSTS: "zoo1:2181,zoo2:2181,zoo3:2181"
      TOPIC_LIST: "topic1:1:5,topic2:3:4"
      AUTO_GEN_BROKER_ID: "true"
      ZK_CHROOT: "test"
    networks:
    - net

networks:
  net:
```

**Public Builds**

https://hub.docker.com/r/dannylesnik/kafka/