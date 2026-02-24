*** Settings ***
Library    AppiumLibrary
Library    ../resources/locators/commonlocators.py
Resource   ../resources/constants.resource
Resource   ../keywords/basepagekeywords.robot

*** Variables ***
${PLUS_BUTTON_id}                     plusIV
${QUANTITY}                           9
${ADD_TO_CART_BUTTON_id}              cartBt
${CART_ITEM_COUNT_id}                 cartTV
${CART_BUTTON_id}                     cartIV
${PROCEED_TO_CHECKOUT_BUTTON_id}      cartBt
${LOGIN_BUTTON_id}                    loginBtn
${FULL_NAME_EDIT_TEXT_id}             fullNameET
${ADDRESS_1_EDIT_TEXT_id}             address1ET
${ADDRESS_2_EDIT_TEXT_id}             address2ET
${CITY_EDIT_TEXT_id}                  cityET
${STATE_EDIT_TEXT_id}                 stateET
${ZIP_EDIT_TEXT_id}                   zipET
${COUNTRY_EDIT_TEXT_id}               countryET
${PAYMENT_FULL_NAME_EDIT_TEXT_id}     nameET
${CARD_NUMBER_EDIT_TEXT_id}           cardNumberET
${EXPIRATION_DATE_EDIT_TEXT_id}       expirationDateET
${SECURITY_CODE_EDIT_TEXT_id}         securityCodeET
${PAYMENT_BUTTON_id}                  paymentBtn
${TIMEOUT}                            10s

*** Keywords ***
the user increases item quantity to ${quantity} items
    ${PLUS_BUTTON}=    Get Element By Id     ${PLUS_BUTTON_id}
    FOR    ${i}    IN RANGE    ${quantity}
        Click Element    ${PLUS_BUTTON}
    END

the user taps on the add to cart button
    the user taps on element with id "${ADD_TO_CART_BUTTON_id}"

the user asserts the displayed number of items in the cart
    ${CART_ITEM_COUNT}=    Get Element By Id     ${CART_ITEM_COUNT_id}
    Page Should Contain Element    ${CART_ITEM_COUNT}
    ${CART_ITEM_COUNT_TEXT}=    Get Text    ${CART_ITEM_COUNT}
    ${expected}=    Evaluate    ${quantity} + ${DEFAULT_ITEM_QUANTITY}
    Should Be Equal As Strings    ${CART_ITEM_COUNT_TEXT}    ${expected}

the user clicks on the cart button
    the user taps on element with id "${CART_BUTTON_id}"
    Wait Until Page Contains    Proceed To Checkout    timeout=${TIMEOUT}

the user clicks on the proceed to checkout button
    the user taps on element with id "${PROCEED_TO_CHECKOUT_BUTTON_id}"
    ${LOGIN_BUTTON}=    Get Element By Id     ${LOGIN_BUTTON_id}
    Wait Until Page Contains Element    ${LOGIN_BUTTON}    timeout=${TIMEOUT}

the user enters shipping address information
    the user enters "${FULL_NAME}" in field with id "${FULL_NAME_EDIT_TEXT_id}"
    the user enters "${ADDRESS_1}" in field with id "${ADDRESS_1_EDIT_TEXT_id}"
    the user enters "${ADDRESS_2}" in field with id "${ADDRESS_2_EDIT_TEXT_id}"
    the user enters "${CITY}" in field with id "${CITY_EDIT_TEXT_id}"
    the user enters "${STATE}" in field with id "${STATE_EDIT_TEXT_id}"
    the user enters "${ZIP}" in field with id "${ZIP_EDIT_TEXT_id}"
    the user enters "${COUNTRY}" in field with id "${COUNTRY_EDIT_TEXT_id}"

the user taps on the payment button
    the user taps on element with id "${PAYMENT_BUTTON_id}"
    Wait Until Page Contains    Review Order    timeout=${TIMEOUT}

the user enters a payment method information
    the user enters "${FULL_NAME}" in field with id "${PAYMENT_FULL_NAME_EDIT_TEXT_id}"
    the user enters "${CARD_NUMBER}" in field with id "${CARD_NUMBER_EDIT_TEXT_id}"
    the user enters "${EXPIRATION_DATE}" in field with id "${EXPIRATION_DATE_EDIT_TEXT_id}"
    the user enters "${SECURITY_CODE}" in field with id "${SECURITY_CODE_EDIT_TEXT_id}"

the user taps on the review order button
    the user taps on element with id "${PAYMENT_BUTTON_id}"
    Wait Until Page Contains    Place Order    timeout=${TIMEOUT}

the user taps on the place order button
    the user taps on element with id "${PAYMENT_BUTTON_id}"
    Wait Until Page Contains    Checkout Complete    timeout=${TIMEOUT}
    Wait Until Page Contains    Continue Shopping    timeout=${TIMEOUT}
    Wait Until Page Contains    Thank you for your order    timeout=${TIMEOUT}
