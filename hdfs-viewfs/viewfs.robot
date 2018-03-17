*** Settings ***
Documentation       Testing viewfs configuration
Library             OperatingSystem
Suite Setup         Startup cluster
Suite Teardown      Docker compose down
Resource            ../robotlib/docker.robot

*** Variables ***
${PREFIX}               hdfsviewfs
${COMPOSEFILE}          ${CURDIR}/docker-compose.yaml

*** Test Cases ***

Daemons are running without error
    Daemon is running without error           nnx
    Daemon is running without error           nny
    Daemon is running without error           datanodex
    Daemon is running without error           datanodey

Check hadoop version
    ${version}          Execute on      nnx                hadoop version
    Log                 ${version}


Ensure both namespaces are mounted
                    Execute on      nnx         hdfs dfs -mkdir hdfs://nnx/first
                    Execute on      nny         hdfs dfs -mkdir hdfs://nny/second
    ${result} =     Execute on      nny         hdfs dfs -ls viewfs:///
                    Should contain  ${result}   x
                    Should contain  ${result}   y
    ${result} =     Execute on      nny         hdfs dfs -ls viewfs:///x
                    Should contain  ${result}   first
    ${result} =     Execute on      nny         hdfs dfs -ls viewfs:///y
                    Should contain  ${result}   second

*** Keywords ***

Startup cluster
        Startup Docker Compose
        Wait Until Keyword Succeeds             1min    5sec    Does log contain   nnx     Processing first storage report
        Wait Until Keyword Succeeds             1min    5sec    Does log contain   nny     Processing first storage report




