*** Settings ***
Resource         ../resources/indexer.resource
Test Setup       Run Keywords  Open Test Application   The application is launched   The app content should be visible
Suite Teardown   Close Test Application
Test Tags        place_order

*** Test Cases ***
User Should Be Able To Place An Order
    [Documentation]    Verify the user can place an order
            [Tags]    LotfiOTAI-021
    Given the app is on the home screen
    When the user taps on a product
    Then the product detail screen should be displayed
    And the user increases item quantity to ${QUANTITY} items
    And the user taps on the add to cart button
    Then the user asserts the displayed number of items in the cart
    Then the user clicks on the cart button
    Then the user clicks on the proceed to checkout button
    Then the user enters credentials    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Then the user enters shipping address information
    Then the user taps on the payment button
    Then the user enters a payment method information
    Then the user taps on the review order button
    Then the user taps on the place order button
    Sleep    5s