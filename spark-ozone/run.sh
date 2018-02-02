#/usr/bin/env bash

export SPARK_DIST_CLASSPATH="$(hadoop classpath):/opt/hadoop/share/hadoop/tools/lib/hadoop-ozone-3.1.0-SNAPSHOT.jar"


/opt/spark/bin/spark-submit \
  --deploy-mode cluster \
  --master yarn \
  --class org.apache.spark.examples.JavaWordCount /opt/spark/examples/jars/spark-examples_2.11-2.2.1.jar \
  /qwe



#  --conf 'spark.hadoop.fs.defaultFS=o3://datanode:9874/test/bucket1/' \
#  --conf 'spark.executor.extraJavaOptions=-Dfs.o3.impl=org.apache.hadoop.fs.ozone.OzoneFileSystem' \
#  --conf 'spark.driver.extraJavaOptions=-Dfs.o3.impl=org.apache.hadoop.fs.ozone.OzoneFileSystem' \
