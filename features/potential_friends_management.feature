# 2. Potential Friends Management:

Feature: Potential Friends Management
# # ======================================================================================================================================================================================
# 2.1. Potential Friend Search:
Scenario: User searches for a potential friend
    Given the following users are registered
      | email              | password  | repeat_password | name          | date_of_birth | phone        | description | location                           | auto_location_detection |
      | taleh958@gmail.com | Taleh2002 | Taleh2002       | Taleh Taghi   | 2002-01-01    | +37242425454 | Description | Narva mnt 27, 51009 Tartu, Estonia | false                   |
      | tahmina@gmail.com  | Taleh2002 | Taleh2002       | Tahmina Taghi | 2002-01-01    | +37242425455 | Description | Narva mnt 25, 51009 Tartu, Estonia | false                   |
    Given the user with email "taleh958@gmail.com" and password "Taleh2002" wants to login
    And the user navigates to login page
    And the user fills login inputs
    And the user clicks login button
    And the user navigates to friend search
    And the user searches "tah"
    And the user will see Tahmina Taghi in the search results

# # ======================================================================================================================================================================================
# 2.2. Potential Friend Sorting:
Scenario: Potential Friend Sorting
    Given the following users are registered
      | email              | password  | repeat_password | name          | date_of_birth | phone        | description | location                             | auto_location_detection |
      | taleh958@gmail.com | Taleh2002 | Taleh2002       | Taleh Taghi   | 2002-01-01    | +37242425454 | Description | Narva mnt 27, 51009 Tartu, Estonia   | false                   |
      | tahmina@gmail.com  | Taleh2002 | Taleh2002       | Tahmina Taghi | 2002-01-01    | +37242425455 | Description | Narva mnt 25, 51009 Tartu, Estonia   | false                   |
      | eldaniz@gmail.com  | Taleh2002 | Taleh2002       | Eldaniz Akbar | 2002-01-01    | +37242425455 | Description | Turu tänav T21, 51013 Tartu, Estonia | false                   |
    Given the user with email "taleh958@gmail.com" and password "Taleh2002" wants to login
    And the user navigates to login page
    And the user fills login inputs
    And the user clicks login button
    And the user navigates to friend search
    And the user clicks the search button
    And the user will see Tahmina Taghi before Eldaniz Akbar in the search results

# # ======================================================================================================================================================================================
# 2.3. Potential Friends Details:
Scenario: Potential Friends Details
      Given the following users are registered
      | email              | password  | repeat_password | name          | date_of_birth | phone        | description | location                           | auto_location_detection |
      | taleh958@gmail.com | Taleh2002 | Taleh2002       | Taleh Taghi   | 2002-01-01    | +37242425454 | Description | Narva mnt 27, 51009 Tartu, Estonia | false                   |
      | tahmina@gmail.com  | Taleh2002 | Taleh2002       | Tahmina Taghi | 2002-01-01    | +37242425455 | Description | Narva mnt 25, 51009 Tartu, Estonia | false                   |
    Given the user with email "taleh958@gmail.com" and password "Taleh2002" wants to login
    And the user navigates to login page
    And the user fills login inputs
    And the user clicks login button
    And the user navigates to friend search
    And the user searches "tah"
    When the user clicks the View Profile button
    Then the user should be navigated to the details page of another user


# # ======================================================================================================================================================================================
# 2.4. Potential Friends Deletion:
Scenario: Potential Friends Deletion
      Given the following users are registered
      | email              | password  | repeat_password | name          | date_of_birth | phone        | description | location                           | auto_location_detection |
      | taleh958@gmail.com | Taleh2002 | Taleh2002       | Taleh Taghi   | 2002-01-01    | +37242425454 | Description | Narva mnt 27, 51009 Tartu, Estonia | false                   |
      | tahmina@gmail.com  | Taleh2002 | Taleh2002       | Tahmina Taghi | 2002-01-01    | +37242425455 | Description | Narva mnt 25, 51009 Tartu, Estonia | false                   |
    Given the user with email "taleh958@gmail.com" and password "Taleh2002" wants to login
    And the user navigates to login page
    And the user fills login inputs
    And the user clicks login button
    And the user navigates to friend search
    And the user searches "tah"
    Then the user clicks the Ignore button
    And the user searches "Tahmina"
    Then the user should see No users found in the search results


# # ======================================================================================================================================================================================
# 2.5. Friend Requests:    
Scenario: Friend Requests
    Given the following users are registered
      | email              | password  | repeat_password | name          | date_of_birth | phone        | description | location                           | auto_location_detection |
      | taleh958@gmail.com | Taleh2002 | Taleh2002       | Taleh Taghi   | 2002-01-01    | +37242425454 | Description | Narva mnt 27, 51009 Tartu, Estonia | false                   |
      | tahmina@gmail.com  | Taleh2002 | Taleh2002       | Tahmina Taghi | 2002-01-01    | +37242425455 | Description | Narva mnt 25, 51009 Tartu, Estonia | false                   |
    Given the user with email "taleh958@gmail.com" and password "Taleh2002" wants to login
    And the user navigates to login page
    And the user fills login inputs
    And the user clicks login button
    And the user navigates to friend search
    And the user searches "tah"
    When the user clicks the Show Interest button
    Then the button should be renamed to Interested











