*** Settings ***
Library    AppiumLibrary
Library    ../resources/locators/commonlocators.py
Variables    ../resources/config/credentials.py

*** Variables ***
${LOGIN_MENU_ITEM_text}             Log In
${MENU_BUTTON_id}                   menuIV
${USERNAME_Resource_Id}             nameET
${PASSWORD_Resource_Id}             passwordET
${LOGIN_BUTTON_Resource_Id}         loginBtn
${INVALID_USERNAME}                 invalid@example.com
${INVALID_PASSWORD}                 ${EMPTY}
${TIMEOUT}                          10s

*** Keywords ***
The user is on the login page
    the user taps on element with id "${MENU_BUTTON_id}"
    ${LOGIN_MENU_ITEM}=      Get Element By Text    ${LOGIN_MENU_ITEM_text}
    Click Element    ${LOGIN_MENU_ITEM}
    ${username_field}=    Get Element By Resource Id    ${USERNAME_Resource_Id}
    Wait Until Page Contains Element    ${username_field}     timeout=${TIMEOUT}

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
    Wait Until Page Contains    Products    timeout=${TIMEOUT}
    Log    Login successful - Products page is displayed

The Products page should not be displayed
    Sleep    3s
    Page Should Contain Text    Enter Password    timeout=${TIMEOUT}