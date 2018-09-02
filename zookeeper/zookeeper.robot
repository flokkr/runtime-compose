*** Settings ***
Documentation       Smoketesting zookeeper cluster
Library             OperatingSystem
Suite Setup         Startup cluster
Suite Teardown      Docker compose down
Resource            ${CURDIR}/../robotlib/docker.robot

*** Variables ***
${PREFIX}               zookeeper
${COMPOSEFILE}          ${CURDIR}/docker-compose.yaml

*** Test Cases ***

Daemons are running without error
    Daemon is running without error           zookeeper1
    Daemon is running without error           zookeeper2
    Daemon is running without error           zookeeper3

Write once read everywhere
    ${res} =     Execute on             zookeeper1         zkCli.sh create /testnode testvalue
    ${res} =     Execute on             zookeeper1         zkCli.sh get /testnode
                 Should contain         ${res}             testvalue
    ${res} =     Execute on             zookeeper2         zkCli.sh get /testnode
                 Should contain         ${res}             testvalue
    ${res} =     Execute on             zookeeper3         zkCli.sh get /testnode
                 Should contain         ${res}             testvalue


*** Keywords ***

Startup cluster
        Startup Docker Compose
        Wait Until Keyword Succeeds             1min    5sec    Does log contain   zookeeper1     LEADER ELECTION TOOK
        Wait Until Keyword Succeeds             1min    5sec    Does log contain   zookeeper2     LEADER ELECTION TOOK
        Wait Until Keyword Succeeds             1min    5sec    Does log contain   zookeeper3     LEADER ELECTION TOOK
