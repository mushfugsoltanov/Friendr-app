# 1. User Management:

Feature: User Management
# ======================================================================================================================================================================================
# 1.1. User Self-Registration:
  Scenario: User Registration Success
    Given the user navigates to the registration page
    When the user fills in the registration form with valid details
    Then the user should be successfully registered

  Scenario: User Registration Failure
    Given the user navigates to the registration page
    When the user fills in the registration form with invalid details
    Then the system should display an error message
    And the user should remain on the registration page

# ======================================================================================================================================================================================
# 1.2. User authentication/authorization:
Scenario: User Login
  Given the following users are registered
      | email              | password  | repeat_password | name          | date_of_birth | phone        | description | location                           | auto_location_detection |
      | taleh958@gmail.com | Taleh2002 | Taleh2002       | Taleh Taghi   | 2002-01-01    | +37242425454 | Description | Narva mnt 27, 51009 Tartu, Estonia | false                   |
    Given the user with email "taleh958@gmail.com" and password "Taleh2002" wants to login
    And the user navigates to login page
    And the user fills login inputs
    And the user clicks login button
    Then the user should be successfully logged in

Scenario: User Logout
  Given the following users are registered
      | email              | password  | repeat_password | name          | date_of_birth | phone        | description | location                           | auto_location_detection |
      | taleh958@gmail.com | Taleh2002 | Taleh2002       | Taleh Taghi   | 2002-01-01    | +37242425454 | Description | Narva mnt 27, 51009 Tartu, Estonia | false                   |
    Given the user with email "taleh958@gmail.com" and password "Taleh2002" wants to login
    And the user navigates to login page
    And the user fills login inputs
    And the user clicks login button
    Then the user should be successfully logged in
    And the user navigates to log out after log in
    Then the user should be successfully logged out

Scenario: User authorization
    And the user navigates to my profile page without login
    Then the user will see You must log in to access this page.

# ======================================================================================================================================================================================
# 1.3. User Interests and Hates: 
Scenario: User Interests and Hates
    Given the following users are registered
      | email              | password  | repeat_password | name          | date_of_birth | phone        | description | location                           | auto_location_detection |
      | taleh958@gmail.com | Taleh2002 | Taleh2002       | Taleh Taghi   | 2002-01-01    | +37242425454 | Description | Narva mnt 27, 51009 Tartu, Estonia | false                   |
    Given the user with email "taleh958@gmail.com" and password "Taleh2002" wants to login
    And the user navigates to login page
    And the user fills login inputs
    And the user clicks login button
    And the user navigates to my profile page
    And the user see his-her information
    When the user clicks edit button
    And the user fills topic inputs
    And the user clicks save button
    Then the user should see his-her interests and hates

# ======================================================================================================================================================================================
# 1.4. Automatic User Location: 
Scenario: Update Location in Friend Search
    Given the user navigates to the registration page
    And the user fills in the registration form with valid details
    And the user navigates to friend search
    And the user see successfully update location

# ======================================================================================================================================================================================
# 1.5. Manual User Location:
Scenario: Manual User Location
    Given the following users are registered
      | email              | password  | repeat_password | name          | date_of_birth | phone        | description | location                           | auto_location_detection |
      | taleh958@gmail.com | Taleh2002 | Taleh2002       | Taleh Taghi   | 2002-01-01    | +37242425454 | Description | Narva mnt 27, 51009 Tartu, Estonia | false                   |
    Given the user with email "taleh958@gmail.com" and password "Taleh2002" wants to login
    And the user navigates to login page
    And the user fills login inputs
    And the user clicks login button
    And the user navigates to my profile page
    And the user see his-her information
    When the user clicks edit button
    And the user edit his-her location manually
    And the user clicks save button
    Then the user should see his-her updated location






# ======================================================================================================================================================================================


Scenario: User profile
    Given the following users are registered
      | email              | password  | repeat_password | name          | date_of_birth | phone        | description | location                           | auto_location_detection |
      | taleh958@gmail.com | Taleh2002 | Taleh2002       | Taleh Taghi   | 2002-01-01    | +37242425454 | Description | Narva mnt 27, 51009 Tartu, Estonia | false                   |
    Given the user with email "taleh958@gmail.com" and password "Taleh2002" wants to login
    And the user navigates to login page
    And the user fills login inputs
    And the user clicks login button
    And the user navigates to my profile page
    And the user see his-her information




# ======================================================================================================================================================================================

Scenario: User profile edit
    Given the following users are registered
      | email              | password  | repeat_password | name          | date_of_birth | phone        | description | location                           | auto_location_detection |
      | taleh958@gmail.com | Taleh2002 | Taleh2002       | Taleh Taghi   | 2002-01-01    | +37242425454 | Description | Narva mnt 27, 51009 Tartu, Estonia | false                   |
    Given the user with email "taleh958@gmail.com" and password "Taleh2002" wants to login
    And the user navigates to login page
    And the user fills login inputs
    And the user clicks login button
    And the user navigates to my profile page
    And the user see his-her information
    When the user clicks edit button
    And the user fills topic inputs
    And the user clicks save button
    Then the user should see his-her updated information




