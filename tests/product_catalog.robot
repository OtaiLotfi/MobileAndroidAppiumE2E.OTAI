*** Settings ***
Resource         ../resources/indexer.robot
Test Setup       Run Keywords  Open Test Application   The application is launched   The app content should be visible
Suite Teardown   Close Test Application
Test Tags        product_catalog

*** Test Cases ***
Product Catalog Should Display Items
    [Documentation]    Verify the home screen shows product items with titles and prices
        [Tags]    LotfiOTAI-011
    Given the app is on the home screen
    Then the product titles should be visible
    And the product prices should be visible
    And the product images should be visible

User Should Be Able To Open A Product
    [Documentation]    Verify tapping a product navigates to the product detail screen
            [Tags]    LotfiOTAI-012
    Given the app is on the home screen
    When the user taps on a product
    Then the product detail screen should be displayed
    And the user navigates back