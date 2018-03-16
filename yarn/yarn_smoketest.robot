*** Settings ***
Documentation       Smoketesting Yarn cluster
Library             OperatingSystem
Suite Setup         Startup cluster
#Suite Teardown      Docker compose down
Resource            ../robotlib/docker.robot

*** Variables ***
${PREFIX}               yarn
${COMPOSEFILE}          ${CURDIR}/docker-compose.yaml

*** Test Cases ***

Daemons are running without error
    Daemon is running without error           namenode
    Daemon is running without error           datanode
    Daemon is running without error           resourcemanager
    Daemon is running without error           nodemanager

Calculate PI with mapreduce job
    ${examplejar} =     Execute on      resourcemanager         find /opt/hadoop -name "hadoop-mapreduce-examples*.jar" | grep -v sources | grep -v test
    ${result} =         Execute on      resourcemanager         yarn jar ${examplejar} pi 10 100
                        Should contain  ${result}               Job Finished
                        Should contain  ${result}               Estimated value of Pi is 3.14

Calculate word counts
    ${examplejar} =     Execute on      resourcemanager         find /opt/hadoop -name "hadoop-mapreduce-examples*.jar" | grep -v sources | grep -v test
                        Execute on      resourcemanager         hdfs dfs -copyFromLocal /opt/testdata/big.txt /
    ${result} =         Execute on      resourcemanager         yarn jar ${examplejar} wordcount /big.txt /wordcount
                        Should contain  ${result}               completed successfully
                        Execute on      resourcemanager         hdfs dfs -copyToLocal /wordcount/part-r-00000 /tmp/result
                        Run             docker cp ${PREFIX}_resourcemanager_1:/tmp/result /tmp/result
    ${youngs} =         Grep File       /tmp/result             young
                        Should Contain  ${youngs}               552
                        Remove File     /tmp/result

*** Keywords ***

Startup cluster
        Startup Docker Compose
        Wait Until Keyword Succeeds             1min    5sec    Does log contain   resourcemanager     Node Transitioned from NEW to RUNNING




