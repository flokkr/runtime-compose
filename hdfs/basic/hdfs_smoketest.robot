*** Settings ***
Documentation       Smoketesting HDFS cluster
Library             OperatingSystem
Suite Setup         Startup cluster
Suite Teardown      Docker compose down
Resource            ${CURDIR}/../../robotlib/docker.robot

*** Variables ***
${PREFIX}               basic
${COMPOSEFILE}          ${CURDIR}/docker-compose.yaml

*** Test Cases ***

Daemons are running without error
    Daemon is running without error           namenode
    Daemon is running without error           datanode

*** Keywords ***

Startup cluster
        Startup Docker Compose
        Wait Until Keyword Succeeds             1min    5sec    Does log contain   namenode     Processing first storage report




