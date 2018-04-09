*** Settings ***
Documentation       Smoketest with hdsl/ozone.
Library             OperatingSystem
Suite Setup         Startup Cluster
Suite Teardown      Docker compose down
Resource            ../robotlib/docker.robot
Force Tags          ozone

*** Variables ***
${PREFIX}               ozone
${COMPOSEFILE}          ${CURDIR}/docker-compose.yaml
${COMMON_REST_HEADER}   -H "x-ozone-user: bilbo" -H "x-ozone-version: v1" -H  "Date: Mon, 26 Jun 2017 04:23:30 GMT" -H "Authorization:OZONE root"


*** Test Cases ***

Daemons are running without error
    Daemon is running without error           ksm
    Daemon is running without error           scm
    Daemon is running without error           namenode
    Daemon is running without error           datanode

Check if datanode is connected to the scm
    Wait Until Keyword Succeeds     2min    5sec    Have healthy datanodes   1

Scale it up to 5 datanodes
    Scale nodes up                  datanode    5
    Wait Until Keyword Succeeds     2min        5sec    Have healthy datanodes   5

Test rest interface
    ${result} =     Execute on      datanode     curl -i -X POST ${COMMON_RESTHEADER} "http://localhost:9880/volume1"
    Should contain  ${result}   201 Created

Check webui static resources
    ${result} =			Execute on		    scm		        curl -s -I http://localhost:9876/static/bootstrap-3.0.2/js/bootstrap.min.js
	                    Should contain		${result}		200
    ${result} =			Execute on		    ksm		        curl -s -I http://localhost:9874/static/bootstrap-3.0.2/js/bootstrap.min.js
	                    Should contain		${result}		200

Start freon testing
    ${result} =		Execute on		                ksm		 ozone freon -numOfVolumes 5 -numOfBuckets 5 -numOfKeys 5 -numOfThreads 10
	                Wait Until Keyword Succeeds	    3min	    10sec		Should contain		${result}		Number of Keys added: 125
	                Should Not Contain		        ${result}	ERROR

*** Keywords ***

Have healthy datanodes
    [arguments]      ${requirednodes}
    ${result} =         Execute on          scm                 curl -s 'http://localhost:9876/jmx?qry=Hadoop:service=SCMNodeManager,name=SCMNodeManagerInfo' | jq -r '.beans[0].NodeCount[] | select(.key=="HEALTHY") | .value'
                        Should Be Equal     ${result}           ${requirednodes}

Scale datanodes up
    [arguments]     ${requirednodes}
    Run             docker-compose scale datanode=${requirednodes}


Startup cluster
        Startup Docker Compose
        Wait Until Keyword Succeeds             1min    5sec    Does log contain   namenode     Processing first storage report
