*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
${base_url}    https://api-energy-k8s.test.virtaglobal.com


*** Test Cases ***
Verify each station version
    [Template]    Station ${station_id} version should be higher than 1.6
    1
    2
    3
    4
    5

Verify each station interval
    [Template]    Station ${station_id} interval should be from 1 to 60
    1
    2
    3
    4
    5

Set Minimum Valid Boundary Value
    [Template]    Setting value to ${payload} for station ${station_id} should be ${result}
    1    1    OK
    1    2    OK
    1    3    OK
    1    4    OK
    1    5    OK

Set Maximum Valid Boundary Value
    [Template]    Setting value to ${payload} for station ${station_id} should be ${result}
    10    1    OK
    10    2    OK
    10    3    OK
    10    4    OK
    10    5    OK

Should Not Set Lower Invalid Boundary Value
    [Template]    Setting value to ${payload} for station ${station_id} should be ${result}
    0    1    FAILED
    0    2    FAILED
    0    3    FAILED
    0    4    FAILED
    0    5    FAILED

Should Not Set Higher Invalid Boundary Value
    [Template]    Setting value to ${payload} for station ${station_id} should be ${result}
    11    1    FAILED
    11    2    FAILED
    11    3    FAILED
    11    4    FAILED
    11    5    FAILED

Should Not Set String Values
    [Template]    Setting value to ${payload} for station ${station_id} should be ${result}
    aa    1    FAILED
    bv    2    FAILED
    bf    3    FAILED
    sd    4    FAILED
    ht    5    FAILED

Setting empty values should fail
    [Template]    Setting value to ${payload} for station ${station_id} should be ${result}
    ""    1    FAILED
    ""    2    FAILED
    ""    3    FAILED
    ""    4    FAILED
    ""    5    FAILED

*** Keywords ***
Send a command to station
    [Arguments]    ${station_id}    ${command}    ${payload}=0
    Create Session    versionCheck    ${base_url}    verify=True
    ${body}=    Create Dictionary    command=${command}    payload=${payload}
    ${response}=    POST On Session    versionCheck    /v1/tests/${station_id}    json=${body}
    RETURN    ${response}

Station ${station_id} version should be higher than 1.6
   ${response}    Send a command to station    ${station_id}    getVersion
    Status Should Be    200    ${response}
    Should Be True    ${response.json()}[result] > 1.6

Station ${station_id} interval should be from 1 to 60
    ${response}    Send a command to station    ${station_id}    getInterval
    Status Should Be    200    ${response}
    Should Be True    1 <= ${response.json()}[result] <= 60

Setting value to ${payload} for station ${station_id} should be ${result}
    ${response}    Send a command to station    ${station_id}    setValues    ${payload}
    Status Should Be    200    ${response}
    Should Be Equal    ${response.json()}[result]    ${result}