# 5. General and Extra features:

Feature: General and Extra features
# ======================================================================================================================================================================================
# 5.1. Link to Event Searches:
Scenario: Link to Event Searches
    Given the following users are registered
      | email              | password  | repeat_password | name          | date_of_birth | phone        | description | location                           | auto_location_detection |
      | taleh958@gmail.com | Taleh2002 | Taleh2002       | Taleh Taghi   | 2002-01-01    | +37242425454 | Description | Narva mnt 27, 51009 Tartu, Estonia | false                   |
    Given the user with email "taleh958@gmail.com" and password "Taleh2002" wants to login
    And the user navigates to login page
    And the user fills login inputs
    And the user clicks login button
    And the user navigates to home page
    And the user clicks on Events button
    And the user should see Events Search in that page

# ======================================================================================================================================================================================
# 5.2. Link to Friend List:
Scenario: Link to Friend List
    Given the following users are registered
      | email              | password  | repeat_password | name          | date_of_birth | phone        | description | location                           | auto_location_detection |
      | taleh958@gmail.com | Taleh2002 | Taleh2002       | Taleh Taghi   | 2002-01-01    | +37242425454 | Description | Narva mnt 27, 51009 Tartu, Estonia | false                   |
    Given the user with email "taleh958@gmail.com" and password "Taleh2002" wants to login
    And the user navigates to login page
    And the user fills login inputs
    And the user clicks login button
    And the user navigates to home page
    And the user clicks on Friends button
    And the user should see Friend List in that page

# ======================================================================================================================================================================================
# 5.3. Link to Potential Friends:
Scenario: Link to Potential Friends
    Given the following users are registered
      | email              | password  | repeat_password | name          | date_of_birth | phone        | description | location                           | auto_location_detection |
      | taleh958@gmail.com | Taleh2002 | Taleh2002       | Taleh Taghi   | 2002-01-01    | +37242425454 | Description | Narva mnt 27, 51009 Tartu, Estonia | false                   |
    Given the user with email "taleh958@gmail.com" and password "Taleh2002" wants to login
    And the user navigates to login page
    And the user fills login inputs
    And the user clicks login button
    And the user navigates to home page
    And the user clicks on Potential Friends button
    And the user should see Potential Friends in that page


#======================================================================================================================================================================================
# 5.5. Proposed Feature 1: Change Password:
Scenario: Change Password
    Given the following users are registered
      | email              | password  | repeat_password | name          | date_of_birth | phone        | description | location                           | auto_location_detection |
      | taleh958@gmail.com | Taleh2002 | Taleh2002       | Taleh Taghi   | 2002-01-01    | +37242425454 | Description | Narva mnt 27, 51009 Tartu, Estonia | false                   |
    Given the user with email "taleh958@gmail.com" and password "Taleh2002" wants to login
    And the user navigates to login page
    And the user fills login inputs
    And the user clicks login button
    And the user navigates to settings page
    And the user fills change password inputs
    And the user should see success message about change password


# ======================================================================================================================================================================================
# 5.6. Event Comment:
    Scenario: Event Comment
   Given the following users are registered
     | email              | password  | repeat_password | name          | date_of_birth | phone        | description | location                           | auto_location_detection |
     | taleh958@gmail.com | Taleh2002 | Taleh2002       | Taleh Taghi   | 2002-01-01    | +37242425454 | Description | Narva mnt 27, 51009 Tartu, Estonia | false                   |  
 Given the user with email "taleh958@gmail.com" and password "Taleh2002" wants to login
    And the user navigates to login page
    And the user fills login inputs
    And the user clicks login button
    Then the user should be successfully logged in
    And the user navigates to events page
    Then the user clicks New Event button
    Then the user fills in the event form with valid details
    And the user navigates to events page
    Then the user searches "happy" in events list
    Then the user will successfully see that event
    And the user clicks any Event
    And the user fills message input with Hello word
    Then the "Hello" should appear in chat






