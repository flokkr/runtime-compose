# Test Hadoop3 EC

Start up the cluster:

```
docker-compose up -d
```

Generate a 100Mb file on the namenode

```
dd if=/dev/zero of=/tmp/test bs=1024000 count=10
```

List ec poilicies:

```
docker-compose exec namenode  hdfs ec -enablePolicy -policy RS-3-2-1024k
```

Create a test directory on the hdfs:

```
docker-compose exec namenode hdfs dfs -mkdir /testec
```

Enable ec for the /testec

```
docker-compose exec namenode hdfs ec -setPolicy -path /testec -policy  RS-3-2-1024k
```

Copy the file to the EC enabled dir:

```
docker-compose exec namenode hdfs dfs -put /tmp/test /testec
```

Most probably it will fail if you don't have enough datanode:

```
docker-compose scale datanode=5
```

Check the block pool usage from the namenode ui (http://localhost:9879). You will see ~33.26 MB usage on every node (instead of 100MB on 3 node, which would be the non-ec default)

Stop two datanode

```
docker stop ec_datanode_2
docker stop ec_datanode_5
```

Retrieve the file:

```
docker-compose exec namenode hdfs dfs -get /testec/test /tmp/result
```

Be sure that the file content is good:

```
docker-compose exec namenode md5sum /tmp/result
docker-compose exec namenode md5sum /tmp/test
```
