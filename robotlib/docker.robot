
*** Keywords ***
Daemon is running without error
    [arguments]     ${name}
    ${result} =     Run                     docker ps
                    Should contain          ${result}                           ${PREFIX}_${name}_1
    ${result} =     Run                     docker logs ${PREFIX}_${name}_1
                    Should not contain      ${result}                           ERROR


Startup Docker Compose
    ${rc}       ${stdout} =     Run And Return Rc And Output            docker-compose -f ${COMPOSEFILE} down
    ${rc}       ${stdout} =     Run And Return Rc And Output            docker-compose -f ${COMPOSEFILE} up -d
    Should Be Equal As Integers             ${rc}    0

Does log contain
    [arguments]     ${name}     ${expression}
    ${result} =     Run         docker logs ${PREFIX}_${name}_1
    Should contain  ${result}   ${expression}

Execute on
    [arguments]     ${componentname}    ${command}
    ${return} =     Run                 docker-compose -f ${COMPOSEFILE} exec ${componentname} ${command}
    [return]        ${return}

Docker compose down
    Run         docker-compose -f ${COMPOSEFILE} down

Scale nodes up
    [arguments]     ${servicename}  ${requirednodes}
    Run             docker-compose -f ${COMPOSEFILE} scale ${servicename}=${requirednodes}
