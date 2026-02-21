*** Settings ***
Resource    ${CURDIR}${/}..${/}resources${/}common.resource

Test Setup       Open Test Application
Test Teardown    Close Test Application

*** Test Cases ***
User Should Be Able To Login Successfully
    [Documentation]    Verify login flow with valid credentials
    Wait Until Page Contains Element    accessibility_id=View menu    timeout=20s
    Click Element    accessibility_id=View menu
    Wait Until Page Contains Element    xpath=//*[@text="Log In"]    timeout=10s
    Click Element    xpath=//*[@text="Log In"]
    Wait Until Page Contains Element    xpath=//*[contains(@resource-id,'nameET')]    timeout=10s
    Click Element    xpath=//*[contains(@resource-id,'nameET')]
    Input Text    xpath=//*[contains(@resource-id,'nameET')]    bod@example.com
    Click Element    xpath=//*[contains(@resource-id,'passwordET')]
    Input Text    xpath=//*[contains(@resource-id,'passwordET')]    10203040
    Hide Keyboard
    Click Element    xpath=//*[contains(@resource-id,'loginBtn')] 
    Wait Until Page Contains    Products    timeout=15s
    Log    Login successful - Products page is displayed

User Should Not Be Able To Login Successfully
    [Documentation]    Verify login flow with invalid credentials
    Wait Until Page Contains Element    accessibility_id=View menu    timeout=20s
    Click Element    accessibility_id=View menu
    Wait Until Page Contains Element    xpath=//*[@text="Log In"]    timeout=10s
    Click Element    xpath=//*[@text="Log In"]
    Wait Until Page Contains Element    xpath=//*[contains(@resource-id,'nameET')]    timeout=10s
    Click Element    xpath=//*[contains(@resource-id,'nameET')]
    Input Text    xpath=//*[contains(@resource-id,'nameET')]    invalid@example.com
    Click Element    xpath=//*[contains(@resource-id,'passwordET')]
    Input Text    xpath=//*[contains(@resource-id,'passwordET')]    wrongpassword
    Hide Keyboard
    Click Element    xpath=//*[contains(@resource-id,'loginBtn')] 