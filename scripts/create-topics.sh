#!/bin/bash

function createTopic {
  IFS=':' read -a ARRAY <<< "$1"
  TOPIC_NAME=${ARRAY[0]}
  REPLICATION_FACTOR=${ARRAY[1]}
  NUM_OF_PARTITIONS=${ARRAY[2]}
  if  $KAFKA_HOME/bin/kafka-topics.sh --list --zookeeper $ZK_HOSTS/$ZK_CHROOT | grep -q $TOPIC_NAME
  then
    echo "Kafka topic $TOPIC_NAME already exists!";
  else
    echo "Creating topic $TOPIC_NAME with Replication Factor $REPLICATION_FACTOR and number of partitons $NUM_OF_PARTITIONS"
   $KAFKA_HOME/bin/kafka-topics.sh --create --zookeeper "$ZK_HOSTS/$ZK_CHROOT" --replication-factor $REPLICATION_FACTOR --partitions $NUM_OF_PARTITIONS --topic $TOPIC_NAME
  fi
}

if [ ! -z "$TOPIC_LIST" ]; then
    echo "List of topics to create: $TOPIC_LIST"
    IFS=',' read -a TOPICS_ARRAY <<< "$TOPIC_LIST"
    for i in "${TOPICS_ARRAY[@]}"
    do
    :
      createTopic $i
    done
fi
