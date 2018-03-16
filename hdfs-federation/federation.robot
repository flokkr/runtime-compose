*** Settings ***
Documentation       HDFS Federation test
Library             OperatingSystem
Suite Setup         Startup cluster
Suite Teardown      Docker compose down
Resource            ../robotlib/docker.robot

*** Variables ***
${PREFIX}               hdfsfederation
${COMPOSEFILE}          ${CURDIR}/docker-compose.yaml

*** Test Cases ***

Daemons are running without error
    Daemon is running without error           nna
    Daemon is running without error           nnb
    Daemon is running without error           datanode

Check if the two namespaces are separated
                            Execute on              nna         hdfs dfs -mkdir hdfs:/nna/first
                            Execute on              nnb         hdfs dfs -mkdir hdfs://nnb/second
    ${list} =               Execute on              nna         hdfs dfs -ls hdfs://nna/
                            Should Not Contain      ${list}     second

*** Keywords ***

Startup cluster
        Startup Docker Compose
        Wait Until Keyword Succeeds             1min    5sec    Does log contain   nna     Processing first storage report
        Wait Until Keyword Succeeds             1min    5sec    Does log contain   nnb     Processing first storage report
