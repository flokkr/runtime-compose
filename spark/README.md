
# Spark cluster with Yarn execution

To run the containers

```
docker-compose up -d
```

Create the missing sparklog dir

```
docker-compose exec  namenode hdfs dfs -mkdir /sparklog
```

Start the history server again:

```
docker-compose up -d
```

Do something on spark:

On nodemanager:
```
wget https://..../big.txt
hdfs dfs -copyFromLocal big.txt /big.txt
```

On spark history:
```
./bin/spark-submit  --class org.apache.spark.examples.JavaWordCount ./examples/jars/spark-examples_2.11-2.2.0.jar /big.txt
```
