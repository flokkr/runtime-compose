*** Settings ***
Documentation       Spark smokektest
Library             OperatingSystem
Library             Dialogs
Suite Setup         Startup cluster
Suite Teardown      Docker compose down
Resource            ../robotlib/docker.robot

*** Variables ***
${PREFIX}               spark
${COMPOSEFILE}          ${CURDIR}/docker-compose.yaml

*** Test Cases ***

Daemons are running without error
    Daemon is running without error           namenode
    Daemon is running without error           datanode
    Daemon is running without error           resourcemanager
    Daemon is running without error           nodemanager

Running Wordcount spark job (local)
                        Execute on          namenode        hdfs dfs -copyFromLocal /opt/testdata/big.txt /
    ${result} =         Execute on          sparkhistory    /opt/spark/runner.sh /opt/spark/bin/spark-submit --class org.apache.spark.examples.JavaWordCount /opt/spark/examples/jars/spark-examples_2.11-2.3.0.jar /big.txt
                        Should Contain      ${result}       inflammation: 65
                        Should Contain      ${result}       Successfully stopped SparkContext

Scale the cluster up
    Scale nodes up      nodemanager         4

Running Wordcount spark job (yarn)
                        Execute on          namenode        hdfs dfs -copyFromLocal /opt/testdata/big.txt /
    ${result} =         Execute on          sparkhistory    /opt/spark/runner.sh /opt/spark/bin/spark-submit --deploy-mode cluster --master yarn --class org.apache.spark.examples.JavaWordCount /opt/spark/examples/jars/spark-examples_2.11-2.3.0.jar /big.txt
                        Should Contain      ${result}       final status: SUCCEEDED

*** Keywords ***

Startup cluster
        Startup Docker Compose
        Wait Until Keyword Succeeds             1min    5sec    Does log contain    sparklogdirinit     Process exited with exit code 0
        Wait Until Keyword Succeeds             1min    5sec    Does log contain    sparkhistory        Bound HistoryServer to 0.0.0.0, and started

