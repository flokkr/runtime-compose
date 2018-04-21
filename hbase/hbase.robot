*** Settings ***
Documentation       HBASE test
Library             OperatingSystem
Suite Setup         Startup cluster
Suite Teardown      Docker compose down
Resource            ../robotlib/docker.robot

*** Variables ***
${PREFIX}               hbase
${COMPOSEFILE}          ${CURDIR}/docker-compose.yaml

*** Test Cases ***

Daemons are running without error
    Daemon is running without error           hbasemaster
    Daemon is running without error           datanode

Create and read records
                            Execute on          hbasemaster         bash -c "echo \\"create 't' , 'cf'\\" | hbase shell"
                            Execute on          hbasemaster         bash -c "echo \\"put 't', 'bela', 'cf:fullname', 'Bela Bundasian'\\" | hbase shell"
    ${result} =             Execute on          hbasemaster         bash -c "echo \\"get 't', 'bela'\\" | hbase shell | grep 'cf:fullname'"
                            Should contain      ${result}           Bela Bundasian
*** Keywords ***

Startup cluster
        Startup Docker Compose
        Wait Until Keyword Succeeds             3min    5sec    Does log contain   hbasemaster		Master has completed initialization
