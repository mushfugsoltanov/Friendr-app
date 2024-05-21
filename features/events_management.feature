# 3. Events Management:

Feature: Events Management

# ======================================================================================================================================================================================
# 4.1. Event Organization:
Scenario: Event Organization
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
    Then the user will successfully create event


# ======================================================================================================================================================================================
# 4.2. Event Visibility:
Scenario: Event Visibility
   Given the following users are registered
     | email              | password  | repeat_password | name          | date_of_birth | phone        | description | location                           | auto_location_detection |
     | taleh958@gmail.com | Taleh2002 | Taleh2002       | Taleh Taghi   | 2002-01-01    | +37242425454 | Description | Narva mnt 27, 51009 Tartu, Estonia | false                   |
     | tahmina@gmail.com  | Taleh2002 | Taleh2002       | Tahmina Taghi | 2002-01-01    | +37242425455 | Description | Narva mnt 25, 51009 Tartu, Estonia | false                   |
 Given the user with email "taleh958@gmail.com" and password "Taleh2002" wants to login
    And the user navigates to login page
    And the user fills login inputs
    And the user clicks login button
    Then the user should be successfully logged in
    And the user navigates to events page
    Then the user clicks New Event button
    Then the user fills in the event form as private
    Then the user will successfully create event


# ======================================================================================================================================================================================
# 4.4. Future Events Search: 
Scenario: Future Events Search
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



# ======================================================================================================================================================================================
# 4.7. Created Events Search:
Scenario: Created Events Search
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
    And the user navigates to my events page
    Then the user will successfully see his-her created events


# ======================================================================================================================================================================================
# 4.8. Event Lists Operations:
Scenario: Event Lists Operations
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
    Then the user will successfully see Upcoming Event





# ======================================================================================================================================================================================
# 4.11. Event Lists Topic Filter:
Scenario: Event Lists Topic Filter
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
    Then the user choose a Topic
    Then the user will successfully see event with that topic




# ======================================================================================================================================================================================
# 4.11. Event Lists Date Filter:
Scenario: Event Lists Date Filter
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
    Then the user enter start and end dates
    Then the user will successfully see event with in that date range

