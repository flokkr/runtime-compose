#!/usr/bin/env bash

export HADOOP_CLASSPATH=/opt/hadoop/share/hadoop/tools/lib/hadoop-ozone-3.1.0-SNAPSHOT.jar 

ls > /tmp/file
hdfs dfs -mkdir /sparklog
hdfs dfs -chmod 777 /sparklog
hdfs dfs -chmod 777 /
hdfs oz -createVolume http://datanode:9864/test -user tester -quota 100TB -root
hdfs oz -createBucket http://datanode:9864/test/bucket1
hdfs oz -putKey http://datanode:9864/test/bucket1/key1 --file /tmp/file

