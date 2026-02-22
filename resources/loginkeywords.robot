*** Settings ***
Library    AppiumLibrary
Library    fragmentspage/commonlocators.py
Variables    config/credentials.py

*** Variables ***
${MENU_BUTTON}                      accessibility_id=View menu
${LOGIN_MENU_ITEM}                  xpath=//*[@text="Log In"]
${USERNAME_Resource_Id}             nameET
${PASSWORD_Resource_Id}             passwordET
${LOGIN_BUTTON_Resource_Id}         loginBtn
${INVALID_USERNAME}                 invalid@example.com
${INVALID_PASSWORD}                 ${EMPTY}

*** Keywords ***
The user is on the login page
    Wait Until Page Contains Element    ${MENU_BUTTON}        timeout=20s
    Click Element    ${MENU_BUTTON}
    Wait Until Page Contains Element    ${LOGIN_MENU_ITEM}    timeout=10s
    Click Element    ${LOGIN_MENU_ITEM}
    ${username_field}=    Get Element By Resource Id    ${USERNAME_Resource_Id}
    Wait Until Page Contains Element    ${username_field}     timeout=10s

The user enters credentials
   [Arguments]    ${USERNAME}    ${PASSWORD}
   ${username_field}=    Get Element By Resource Id    ${USERNAME_Resource_Id}
   ${password_field}=    Get Element By Resource Id    ${PASSWORD_Resource_Id}
   ${login_button}=      Get Element By Resource Id    ${LOGIN_BUTTON_Resource_Id}
    Click Element    ${username_field}
    Input Text       ${username_field}    ${USERNAME}
    Click Element    ${password_field}
    Input Text       ${password_field}    ${PASSWORD}
    Hide Keyboard
    Click Element    ${login_button}

The user taps the login button
    ${login_button}=      Get Element By Resource Id    ${LOGIN_BUTTON_Resource_Id}
    Click Element    ${login_button}

The Products page should be displayed
    Wait Until Page Contains    Products    timeout=15s
    Log    Login successful - Products page is displayed

The Products page should not be displayed
    Sleep    3s
    Page Should Contain Text    Enter Password    timeout=10s