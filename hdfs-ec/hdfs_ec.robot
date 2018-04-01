*** Settings ***
Documentation       Using EC for one directory
Library             OperatingSystem
Suite Setup         Startup cluster
#Suite Teardown      Docker compose down
Resource            ../robotlib/docker.robot

*** Variables ***
${PREFIX}               hdfsec
${COMPOSEFILE}          ${CURDIR}/docker-compose.yaml

*** Test Cases ***

Daemons are running without error
    Daemon is running without error           namenode
    Daemon is running without error           datanode

Scaling up datanodes
# We need at least 5 nodes for RS-3-2
    Scale nodes up                  datanode    5
    Wait Until Keyword Succeeds     2min        5sec    Have healthy datanodes   5

Use EC for a directory
# Example file to copy (10MB)
                    Execute on      namenode        dd if=/dev/zero of=/tmp/test bs=1024000 count=10
                    Execute on      namenode        hdfs ec -enablePolicy -policy RS-3-2-1024k
                    Execute on      namenode        hdfs dfs -mkdir /testec
                    Execute on      namenode        hdfs ec -setPolicy -path /testec -policy RS-3-2-1024k
                    Execute on      namenode        hdfs dfs -put /tmp/test /testec/test
                    Wait Until Keyword Succeeds        1min    5sec    Check data usage
#Be sure that usage is not increasing
                    Sleep           20 seconds
                    Wait Until Keyword Succeeds        1min    5sec    Check data usage

*** Keywords ***

Startup cluster
        Startup Docker Compose
        Wait Until Keyword Succeeds             1min            5sec    Does log contain   namenode     Processing first storage report

Have healthy datanodes
    [arguments]     ${num}
    ${nodes} =      Execute on          namenode        curl 'http://localhost:9870/jmx?qry=Hadoop:service=NameNode,name=NameNodeInfo' | jq -r '.beans[0].LiveNodes' | tr '\\\\' ' ' | jq '.[] | select(.adminState == "In Service") | .adminSate' | wc -l
                    Should Be Equal     ${nodes}        ${num}

Check data usage
#Summary of the used bytes on all nodes
    ${usage} =      Execute on      namenode        curl 'http://localhost:9870/jmx?qry=Hadoop:service=NameNode,name=NameNodeInfo' | jq -r '.beans[0].LiveNodes' | tr '\\\\' ' ' | jq '.[] | select(.adminState == "In Service") | .blockPoolUsed' | awk '{n += $1}; END{print n}'
#Estimated usage is 10MB/3 * (3 + 2)
                    Should be True  ${usage} < 20000000
                    Should be True  ${usage} > 15000000
