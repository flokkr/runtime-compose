*** Settings ***
Documentation       Kerberos test
Library             OperatingSystem
Suite Setup         Startup cluster
Suite Teardown      Docker compose down
Resource            ../robotlib/docker.robot

*** Variables ***
${PREFIX}               kerberos
${COMPOSEFILE}          ${CURDIR}/docker-compose.yaml

*** Test Cases ***

Daemons are running without error
    Daemon is running without error           namenode
    Daemon is running without error           datanode

Initialize kerberos context
                   Execute on        namenode        sudo apk add --update krb5
                   Execute on        namenode        kinit -k -t /opt/hadoop/etc/hadoop/nn.keytab nn/namenode@EXAMPLE.COM
     ${result} =   Execute on        namenode        klist
                   Should contain    ${result}       Default principal: nn/namenode@EXAMPLE.COM

Do hdfs operations
                   Execute on        namenode        hdfs dfs -mkdir /qwe
     ${result} =   Execute on        namenode        hdfs dfs -ls /
                   Should contain    ${result}       qwe


*** Keywords ***

Startup cluster
        Startup Docker Compose
        Wait Until Keyword Succeeds             3min    5sec    Does log contain   namenode		Processing first storage report
