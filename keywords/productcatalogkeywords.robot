*** Settings ***
Library    AppiumLibrary
Library    ../resources/locators/commonlocators.py

*** Variables ***
${PRODUCT_TITLE_id}      productTV
${PRODUCT_PRICE-id}      priceTV
${PRODUCT_IMAGE-id}      productIV
${PRODUCT_IMAGE}         xpath=(//android.widget.ImageView[@content-desc="Product Image"])[3]
${TIMEOUT}               20s

*** Keywords ***
The app is on the home screen
    ${PRODUCT_TITLE}=    Get Element By Id    ${PRODUCT_TITLE_id}
    Wait Until Page Contains Element    ${PRODUCT_TITLE}    timeout=${TIMEOUT}

The product titles should be visible
    ${PRODUCT_TITLE}=    Get Element By Id    ${PRODUCT_TITLE_id}
    Wait Until Page Contains Element    ${PRODUCT_TITLE}    timeout=${TIMEOUT}

The product prices should be visible
    ${PRODUCT_PRICE}=    Get Element By Id     ${PRODUCT_PRICE-id}
    Page Should Contain Element    ${PRODUCT_PRICE}

The product images should be visible
    ${PRODUCT_IMAGE}=    Get Element By Id     ${PRODUCT_IMAGE-id}
    Page Should Contain Element    ${PRODUCT_IMAGE}

The user taps on a product
    Click Element    ${PRODUCT_IMAGE}

The product detail screen should be displayed
    ${PRODUCT_TITLE}=    Get Element By Id    ${PRODUCT_TITLE_id}
    Wait Until Page Contains Element    ${PRODUCT_TITLE}    timeout=${TIMEOUT}
    Log    Product detail screen opened successfully

The user navigates back
    Go Back
