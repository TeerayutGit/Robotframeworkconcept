*** Settings ***
Library    Collections

Suite Setup    Load Sample Form
Suite Teardown    Reset Form State

*** Variables ***
@{LANGUAGE_OPTIONS}    Arabic    English    Hindi    Spanish
@{SKILL_OPTIONS}    Android    C++    Java    Python
@{COUNTRY_OPTIONS}    Australia    India    New Zealand    United States
@{MONTH_OPTIONS}    January    February    March    April    May    June    July    August    September    October    November    December
@{GENDER_OPTIONS}    Male    Female
@{HOBBY_OPTIONS}    Cricket    Movies    Hockey
${FIRST_NAME}    John
${LAST_NAME}    Doe
${ADDRESS}    123 Main Street\nSpringfield
${EMAIL}    john.doe@example.com
${PHONE}    5551234567
${GENDER}    Male
${HOBBY}    Movies
${LANGUAGE}    English
${SKILL}    Java
${COUNTRY}    India
${BIRTH_YEAR}    1990
${BIRTH_MONTH}    March
${BIRTH_DAY}    10
${PASSWORD}    SuperSecret123

*** Test Cases ***
User Can Submit Registration Form
    [Documentation]    Fills in mandatory fields on the sample registration form and submits it.
    Fill In Personal Details
    Select Languages And Skills
    Select Birth Date
    Set Passwords
    Submit Form
    Submission Should Be Successful

*** Keywords ***
Load Sample Form
    Reset Form State
    ${years}=    Evaluate    [str(year) for year in range(1980, 2011)]
    ${days}=    Evaluate    [str(day) for day in range(1, 32)]
    Set Suite Variable    ${YEAR_OPTIONS}    ${years}
    Set Suite Variable    ${DAY_OPTIONS}    ${days}

Reset Form State
    ${form}=    Create Dictionary    submitted=${FALSE}
    Set Suite Variable    ${FORM_STATE}    ${form}

Fill In Personal Details
    Validate Non Empty    First name    ${FIRST_NAME}
    Validate Non Empty    Last name    ${LAST_NAME}
    Validate Non Empty    Address    ${ADDRESS}
    Validate Non Empty    Email    ${EMAIL}
    Validate Non Empty    Phone    ${PHONE}
    Validate Choice    Gender    ${GENDER}    ${GENDER_OPTIONS}
    Validate Choice    Hobby    ${HOBBY}    ${HOBBY_OPTIONS}
    Set Form Value    first_name    ${FIRST_NAME}
    Set Form Value    last_name    ${LAST_NAME}
    Set Form Value    address    ${ADDRESS}
    Set Form Value    email    ${EMAIL}
    Set Form Value    phone    ${PHONE}
    Set Form Value    gender    ${GENDER}
    Set Form Value    hobby    ${HOBBY}

Select Languages And Skills
    Select Language    ${LANGUAGE}
    Select Skill    ${SKILL}
    Select Country    ${COUNTRY}

Select Language
    [Arguments]    ${language}
    Validate Choice    Language    ${language}    ${LANGUAGE_OPTIONS}
    Set Form Value    language    ${language}

Select Skill
    [Arguments]    ${skill}
    Validate Choice    Skill    ${skill}    ${SKILL_OPTIONS}
    Set Form Value    skill    ${skill}

Select Country
    [Arguments]    ${country}
    Validate Choice    Country    ${country}    ${COUNTRY_OPTIONS}
    Set Form Value    country    ${country}

Select Birth Date
    Validate Choice    Birth year    ${BIRTH_YEAR}    ${YEAR_OPTIONS}
    Validate Choice    Birth month    ${BIRTH_MONTH}    ${MONTH_OPTIONS}
    Validate Choice    Birth day    ${BIRTH_DAY}    ${DAY_OPTIONS}
    Set Form Value    birth_year    ${BIRTH_YEAR}
    Set Form Value    birth_month    ${BIRTH_MONTH}
    Set Form Value    birth_day    ${BIRTH_DAY}

Set Passwords
    Validate Non Empty    Password    ${PASSWORD}
    Validate Password Strength    ${PASSWORD}
    Set Form Value    password    ${PASSWORD}

Submit Form
    ${required}=    Create List    first_name    last_name    address    email    phone    gender    language    skill    country    birth_year    birth_month    birth_day    password
    ${missing}=    Create List
    FOR    ${field}    IN    @{required}
        ${has_field}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${FORM_STATE}    ${field}
        IF    not ${has_field}
            Append To List    ${missing}    ${field}
        ELSE
            ${value}=    Get From Dictionary    ${FORM_STATE}    ${field}
            ${has_value}=    Run Keyword And Return Status    Should Not Be Empty    ${value}
            IF    not ${has_value}
                Append To List    ${missing}    ${field}
            END
        END
    END
    Should Be Empty    ${missing}    msg=Cannot submit form. Missing required fields: ${missing}
    Set To Dictionary    ${FORM_STATE}    submitted=${TRUE}

Submission Should Be Successful
    ${submitted}=    Get From Dictionary    ${FORM_STATE}    submitted
    Should Be True    ${submitted}    msg=Form has not been submitted successfully.

Set Form Value
    [Arguments]    ${field}    ${value}
    Set To Dictionary    ${FORM_STATE}    ${field}=${value}

Validate Non Empty
    [Arguments]    ${field_name}    ${value}
    Should Not Be Empty    ${value}    msg=${field_name} must not be empty.

Validate Choice
    [Arguments]    ${field_name}    ${value}    ${options}
    List Should Contain Value    ${options}    ${value}    msg=${field_name} '${value}' is not valid. Allowed: ${options}.

Validate Password Strength
    [Arguments]    ${password}
    ${length}=    Get Length    ${password}
    Should Be True    ${length} >= 8    msg=Password must be at least 8 characters long.
