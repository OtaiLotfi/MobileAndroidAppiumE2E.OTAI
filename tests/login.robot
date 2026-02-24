*** Settings ***
Resource         ../resources/indexer.resource
Test Setup       Run Keywords  Open Test Application   The application is launched   The app content should be visible
Test Teardown    Close Test Application
Test Tags        login

*** Test Cases ***
User Should Be Able To Login Successfully
    [Documentation]    Verify login flow with valid credentials
    [Tags]    LotfiOTAI-001
    Given the user is on the login page
    When the user enters credentials    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Then the Products page should be displayed

User Should Not Be Able To Login Successfully
    [Documentation]    Verify login flow with invalid credentials
    [Tags]    LotfiOTAI-002
    Given the user is on the login page
    When the user enters credentials    ${INVALID_USERNAME}    ${INVALID_PASSWORD}
    And the user taps the login button
    Then the Products page should not be displayed