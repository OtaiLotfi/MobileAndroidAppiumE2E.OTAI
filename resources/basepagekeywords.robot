*** Settings ***
Library    AppiumLibrary

*** Variables ***
${TIMEOUT}            10s

*** Keywords ***
The application is launched
    Log    Application launched via Suite Setup

The app content should be visible
    Wait Until Page Contains Element    xpath=//*    timeout=${TIMEOUT}
    Log    App launched successfully
