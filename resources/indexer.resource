*** Settings ***
Resource    ${CURDIR}${/}..${/}resources${/}common.resource
Library     AppiumLibrary
Resource    ${CURDIR}${/}..${/}keywords${/}loginkeywords.robot
Resource    ${CURDIR}${/}..${/}keywords${/}basepagekeywords.robot
Resource    ${CURDIR}${/}..${/}keywords${/}productcatalogkeywords.robot
Resource    ${CURDIR}${/}..${/}keywords${/}placeorderkeywords.robot
Resource    constants.resource
