*** Settings ***
Documentation       Smoketesting HDFS cluster
Library             OperatingSystem
Suite Setup         Startup cluster
Suite Teardown      Docker compose down
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

Start PI mapreduce jon
    ${examplejar} =     Execute on      resourcemanager         find /opt/hadoop -name "hadoop-mapreduce-examples*.jar" | grep -v sources | grep -v test
    ${result} =         Execute on      resourcemanager         yarn jar ${examplejar} pi 10 100
                        Should contain  ${result}               Job Finished
                        Should contain  ${result}               Estimated value of Pi is 3.14

*** Keywords ***

Startup cluster
        Startup Docker Compose
        Wait Until Keyword Succeeds             1min    5sec    Does log contain   resourcemanager     Node Transitioned from NEW to RUNNING




