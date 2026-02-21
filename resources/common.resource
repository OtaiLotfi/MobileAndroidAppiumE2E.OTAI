*** Settings ***
Library    AppiumLibrary

*** Variables ***
${APPIUM_SERVER}          http://127.0.0.1:4723
${PLATFORM_NAME}          Android
${AUTOMATION_NAME}        UiAutomator2
${APP_PACKAGE}            com.saucelabs.mydemoapp.android
${APP_ACTIVITY}           .view.activities.SplashActivity
${DEVICE_NAME}            emulator-5554
${PLATFORM_VERSION}       14

*** Keywords ***
Open Test Application
    [Documentation]    Opens the Android app on the emulator via Appium
    Open Application    ${APPIUM_SERVER}
    ...    platformName=${PLATFORM_NAME}
    ...    automationName=${AUTOMATION_NAME}
    ...    appPackage=${APP_PACKAGE}
    ...    appActivity=${APP_ACTIVITY}
    ...    deviceName=${DEVICE_NAME}
    ...    platformVersion=${PLATFORM_VERSION}
    ...    noReset=true
    ...    forceAppLaunch=true
    ...    autoGrantPermissions=true

Close Test Application
    [Documentation]    Closes the application and ends the Appium session
    Close Application
