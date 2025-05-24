*** Settings ***
Library           SeleniumLibrary
Library           Collections
Suite Setup       Open Browser To Form
Suite Teardown    Close Browser

*** Variables ***
${URL}            https://demoqa.com/automation-practice-form
${BROWSER}        chrome

${EXPECTED_STATES}    NCR    Uttar Pradesh    Haryana    Rajasthan
${NCR_CITIES}         Delhi    Gurgaon    Noida

*** Test Cases ***
Validate Dropdown Selection On Registration Form
    Verify State Dropdown Options
    Select State And Verify City Options
    Submit Without Selecting City And Verify Submission Blocked
    Select City And Submit Form Successfully

*** Keywords ***
Open Browser To Form
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Element Is Visible    xpath=//div[@id='state']    timeout=10s

Hide Ad Iframe
    Execute Javascript    var ad=document.querySelector('iframe[id^="google_ads_iframe"]'); if(ad){ad.style.display='none';}
    Sleep    1s

Scroll Element Into View
    [Arguments]    ${locator}
    Execute Javascript    arguments[0].scrollIntoView(true);    ${locator}
    Sleep    0.5s

Click State Dropdown Safely
    Hide Ad Iframe
    Scroll Element Into View    xpath=//div[@id='state']
    Wait Until Element Is Visible    xpath=//div[@id='state']    timeout=5s
    Click Element    xpath=//div[@id='state']

Click City Dropdown Safely
    Hide Ad Iframe
    Scroll Element Into View    xpath=//div[@id='city']
    Wait Until Element Is Visible    xpath=//div[@id='city']    timeout=5s
    Click Element    xpath=//div[@id='city']

Verify State Dropdown Options
    Click State Dropdown Safely
    ${state_options}=    Get WebElements    xpath=//div[contains(@class,'css-26l3qy-menu')]//div[contains(@class,'css-11unzgr')]
    ${states}=    Create List
    FOR    ${option}    IN    @{state_options}
        ${text}=    Get Text    ${option}
        Append To List    ${states}    ${text}
    END
    FOR    ${expected}    IN    @{EXPECTED_STATES}
        Should Contain    ${states}    ${expected}
    END
    Click Element    xpath=//body   # Close dropdown

Select State And Verify City Options
    Click State Dropdown Safely
    Click Element    xpath=//div[contains(@class,'css-26l3qy-menu')]//div[text()='NCR']

    Click City Dropdown Safely
    Sleep    1s   # Wait for cities to load
    ${city_options}=    Get WebElements    xpath=//div[contains(@class,'css-26l3qy-menu')]//div[contains(@class,'css-11unzgr')]
    ${cities}=    Create List
    FOR    ${option}    IN    @{city_options}
        ${text}=    Get Text    ${option}
        Append To List    ${cities}    ${text}
    END
    FOR    ${expected}    IN    @{NCR_CITIES}
        Should Contain    ${cities}    ${expected}
    END
    Click Element    xpath=//body   # Close dropdown

Submit Without Selecting City And Verify Submission Blocked
    Hide Ad Iframe
    Click State Dropdown Safely
    Click Element    xpath=//div[contains(@class,'css-26l3qy-menu')]//div[text()='NCR']

    Click Button    id=submit
    Sleep    1s
    Location Should Contain    automation-practice-form

Select City And Submit Form Successfully
    Hide Ad Iframe
    Click State Dropdown Safely
    Click Element    xpath=//div[contains(@class,'css-26l3qy-menu')]//div[text()='NCR']

    Click City Dropdown Safely
    Click Element    xpath=//div[contains(@class,'css-26l3qy-menu')]//div[text()='Delhi']

    Click Button    id=submit
    Sleep    2s
    Page Should Contain Element    id=example-modal-sizes-title-lg
    Element Text Should Be    id=example-modal-sizes-title-lg    Thanks for submitting the form

Close Browser
    Close All Browsers
