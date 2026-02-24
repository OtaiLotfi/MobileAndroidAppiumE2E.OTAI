*** Settings ***
Library    AppiumLibrary
Library    ../resources/locators/commonlocators.py

*** Variables ***
${TIMEOUT}            10s

*** Keywords ***
The application is launched
    Log    Application launched via Suite Setup

The app content should be visible
    Wait Until Page Contains Element    xpath=//*    timeout=${TIMEOUT}
    Log    App launched successfully

the user taps on element with id "${element_id}"
    ${ELEMENT}=    Get Element By Id     ${element_id}
    Wait Until Page Contains Element    ${ELEMENT}    timeout=${TIMEOUT}
    Click Element    ${ELEMENT}

the user enters "${text}" in field with id "${field_id}"
    ${FIELD}=    Get Element By Id     ${field_id}
    Wait Until Page Contains Element    ${FIELD}    timeout=${TIMEOUT}
    Input Text    ${FIELD}    ${text}