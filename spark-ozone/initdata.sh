#!/usr/bin/env bash

export HADOOP_TOOLS_OPTIONS=hadoop-ozone-filesystem
export HADOOP_SHELL_PROFILES=ozone

ls > /tmp/file

oz oz -createVolume http://datanode:9880/test -user tester -quota 100TB -root
oz oz -createBucket http://datanode:9880/test/bucket1
oz oz -putKey http://datanode:9880/test/bucket1/key1 --file /tmp/file

hdfs dfs -mkdir /sparklog
hdfs dfs -chmod 777 /sparklog
hdfs dfs -chmod 777 /


