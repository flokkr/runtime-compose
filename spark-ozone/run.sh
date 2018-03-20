#/usr/bin/env bash

export HADOOP_SHELL_PROFILES=ozone
export HADOOP_TOOLS_OPTIONS="hadoop-ozone-filesystem"
export SPARK_DIST_CLASSPATH="$(hadoop classpath)"

ls -1 > /tmp/alice.txt
oz oz -putKey http://datanode:9880/test/bucket1/alice.txt --file /tmp/alice.txt

/opt/spark/bin/spark-submit \
  --class org.apache.spark.examples.JavaWordCount /opt/spark/examples/jars/spark-examples_2.11-2.3.0.jar \
  /alice.txt

#/opt/spark/bin/spark-submit \
#  --deploy-mode cluster \
#  --master yarn \
#  --class org.apache.spark.examples.JavaWordCount /opt/spark/examples/jars/spark-examples_2.11-2.3.0.jar \
#  /alice.txt


#/opt/spark/bin/spark-submit \
#  --deploy-mode cluster \
#  --master yarn \
#  --files file:///opt/spark/conf/log4j.properties  \
#  --driver-java-options "-Dlog4j.configuration=./log4j.properties"  \
#  --conf "spark.executor.extraJavaOptions=-Dlog4j.configuration=./log4j.properties"  \
#  --class org.apache.spark.examples.JavaWordCount /opt/spark/examples/jars/spark-examples_2.11-2.2.1.jar \
#  /qwe




#
#  --conf 'spark.hadoop.fs.defaultFS=o3://datanode:9874/test/bucket1/' \
#  --conf 'spark.executor.extraJavaOptions=-Dfs.o3.impl=org.apache.hadoop.fs.ozone.OzoneFileSystem' \
#  --conf 'spark.driver.extraJavaOptions=-Dfs.o3.impl=org.apache.hadoop.fs.ozone.OzoneFileSystem' \
