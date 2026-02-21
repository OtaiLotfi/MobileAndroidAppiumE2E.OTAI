*** Settings ***
Resource    ${CURDIR}${/}..${/}resources${/}common.resource

Suite Setup       Open Test Application
Suite Teardown    Close Test Application

*** Variables ***
${PRODUCT_TITLE}      id=com.saucelabs.mydemoapp.android:id/productTV
${PRODUCT_PRICE}      id=com.saucelabs.mydemoapp.android:id/priceTV
${PRODUCT_IMAGE}      id=com.saucelabs.mydemoapp.android:id/productIV
${TIMEOUT}            20s

*** Test Cases ***
Product Catalog Should Display Items
    [Documentation]    Verify the home screen shows product items with titles and prices
    Wait Until Page Contains Element    ${PRODUCT_TITLE}    timeout=${TIMEOUT}
    Page Should Contain Element    ${PRODUCT_PRICE}
    Page Should Contain Element    ${PRODUCT_IMAGE}
    Log    Product catalog is displaying items correctly

User Should Be Able To Open A Product
    [Documentation]    Verify tapping a product navigates to the product detail screen
    Wait Until Page Contains Element    ${PRODUCT_TITLE}    timeout=${TIMEOUT}
    ${product_name}=    Get Text    ${PRODUCT_TITLE}
    Log    Tapping on product: ${product_name}
    Click Element    ${PRODUCT_TITLE}
    Wait Until Page Contains Element    id=com.saucelabs.mydemoapp.android:id/productTV    timeout=${TIMEOUT}
    Log    Product detail screen opened successfully
    Go Back
