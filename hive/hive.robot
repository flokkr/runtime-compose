*** Settings ***
Documentation       Hive smokektest
Library             OperatingSystem
Suite Setup         Startup cluster
#Suite Teardown      Docker compose down
Resource            ../robotlib/docker.robot

*** Variables ***
${PREFIX}               hive
${COMPOSEFILE}          ${CURDIR}/docker-compose.yaml

*** Test Cases ***

Daemons are running without error
    Daemon is running without error           namenode
    Daemon is running without error           datanode
    Daemon is running without error           hiveserver2

Creating example table
    ${result} =         Execute on          hiveserver2     beeline -u "jdbc:hive2://hiveserver2:10000" -n hive -f /tmp/testdata.sql
                        Should Contain      ${result}       No rows affected
                        Should Not Contain  ${result}       ERROR
    ${result} =         Execute on          hiveserver2     bash -c 'beeline -u jdbc:hive2://localhost:10000 -n hive -f <(echo show tables) --outputformat=csv2'
                        Should Contain      ${result}       test
                        Should Contain      ${result}       1 row selected


*** Keywords ***

Startup cluster
        Startup Docker Compose
        Wait Until Keyword Succeeds             3min    5sec    Does log contain    hiveserver2     Web UI has started on port

