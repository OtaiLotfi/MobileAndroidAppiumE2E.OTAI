*** Settings ***
Resource    ${CURDIR}${/}..${/}resources${/}common.resource

Suite Setup       Open Test Application
Suite Teardown    Close Test Application

*** Test Cases ***
App Should Launch Successfully
    [Documentation]    Verify the app launches without errors
    AppiumLibrary.Wait Until Page Contains Element    xpath=//*    timeout=10
    Log    App launched successfully
