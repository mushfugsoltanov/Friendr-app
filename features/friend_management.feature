# 3. Friend Management:

Feature: Friend Management

# # ======================================================================================================================================================================================
# 3.1. Friends Visualization:
Scenario: Friends Visualization
  Given the following users are registered
    | email              | password  | repeat_password | name          | date_of_birth | phone        | description | location                           | auto_location_detection |
    | taleh958@gmail.com | Taleh2002 | Taleh2002       | Taleh Taghi   | 2002-01-01    | +37242425454 | Description | Narva mnt 27, 51009 Tartu, Estonia | false                   |
    | tahmina@gmail.com  | Taleh2002 | Taleh2002       | Tahmina Taghi | 2002-01-01    | +37242425455 | Description | Narva mnt 25, 51009 Tartu, Estonia | false                   |
  Given the user with email "tahmina@gmail.com" and password "Taleh2002" wants to login
  And the user navigates to login page
  And the user fills login inputs
  And the user clicks login button
  And the user navigates to friend search
  And the user searches "tal"
  And the user clicks the Show Interest button
  And the user navigates to log out
  Given the user with email "taleh958@gmail.com" and password "Taleh2002" wants to login
  And the user navigates to login page
  And the user fills login inputs
  And the user clicks login button
  And the user navigates to friend search
  And the user searches "tah"
  And the user clicks the Accept Interest button
  And the user navigates to friends list
  Then the user will see Tahmina Taghi in the friends list

# # ======================================================================================================================================================================================
# 3.2. Friends Filtering:
Scenario: Friends Filtering
  Given the following users are registered
    | email              | password  | repeat_password | name          | date_of_birth | phone        | description | location                           | auto_location_detection |
    | taleh958@gmail.com | Taleh2002 | Taleh2002       | Taleh Taghi   | 2002-01-01    | +37242425454 | Description | Narva mnt 27, 51009 Tartu, Estonia | false                   |
    | tahmina@gmail.com  | Taleh2002 | Taleh2002       | Tahmina Taghi | 2002-01-01    | +37242425455 | Description | Narva mnt 25, 51009 Tartu, Estonia | false                   |
  Given the user with email "tahmina@gmail.com" and password "Taleh2002" wants to login
  And the user navigates to login page
  And the user fills login inputs
  And the user clicks login button
  And the user navigates to friend search
  And the user searches "tal"
  And the user clicks the Show Interest button
  And the user navigates to log out
  Given the user with email "taleh958@gmail.com" and password "Taleh2002" wants to login
  And the user navigates to login page
  And the user fills login inputs
  And the user clicks login button
  And the user navigates to friend search
  And the user searches "tah"
  And the user clicks the Accept Interest button
  And the user navigates to friends list
  And the user searches "tah"
  Then the user will see Tahmina Taghi in the friends list

# # ======================================================================================================================================================================================
# 3.3. Friends Details:
Scenario: Friends Details
  Given the following users are registered
    | email              | password  | repeat_password | name          | date_of_birth | phone        | description | location                           | auto_location_detection |
    | taleh958@gmail.com | Taleh2002 | Taleh2002       | Taleh Taghi   | 2002-01-01    | +37242425454 | Description | Narva mnt 27, 51009 Tartu, Estonia | false                   |
    | tahmina@gmail.com  | Taleh2002 | Taleh2002       | Tahmina Taghi | 2002-01-01    | +37242425455 | Description | Narva mnt 25, 51009 Tartu, Estonia | false                   |
  Given the user with email "tahmina@gmail.com" and password "Taleh2002" wants to login
  And the user navigates to login page
  And the user fills login inputs
  And the user clicks login button
  And the user navigates to friend search
  And the user searches "tal"
  And the user clicks the Show Interest button
  And the user navigates to log out
  Given the user with email "taleh958@gmail.com" and password "Taleh2002" wants to login
  And the user navigates to login page
  And the user fills login inputs
  And the user clicks login button
  And the user navigates to friend search
  And the user searches "tah"
  And the user clicks the Accept Interest button
  And the user navigates to friends list
  When the user clicks the View Profile button
  Then the user should be navigated to the profile page of the friend


# # ======================================================================================================================================================================================
# 3.4. Unfriend:
Scenario: Unfriend
  Given the following users are registered
    | email              | password  | repeat_password | name          | date_of_birth | phone        | description | location                           | auto_location_detection |
    | taleh958@gmail.com | Taleh2002 | Taleh2002       | Taleh Taghi   | 2002-01-01    | +37242425454 | Description | Narva mnt 27, 51009 Tartu, Estonia | false                   |
    | tahmina@gmail.com  | Taleh2002 | Taleh2002       | Tahmina Taghi | 2002-01-01    | +37242425455 | Description | Narva mnt 25, 51009 Tartu, Estonia | false                   |
  Given the user with email "tahmina@gmail.com" and password "Taleh2002" wants to login
  And the user navigates to login page
  And the user fills login inputs
  And the user clicks login button
  And the user navigates to friend search
  And the user searches "tal"
  And the user clicks the Show Interest button
  And the user navigates to log out
  Given the user with email "taleh958@gmail.com" and password "Taleh2002" wants to login
  And the user navigates to login page
  And the user fills login inputs
  And the user clicks login button
  And the user navigates to friend search
  And the user searches "tah"
  And the user clicks the Accept Interest button
  And the user navigates to friends list
  And the user clicks the Unfriend button
  Then the user will not see "tah" in friends list

# # ======================================================================================================================================================================================
# 3.5. Friends Chat: 
    Scenario: Friends Chat
        Given the following users are registered
            | email              | password  | repeat_password | name          | date_of_birth | phone        | description | location                           | auto_location_detection |
            | taleh958@gmail.com | Taleh2002 | Taleh2002       | Taleh Taghi   | 2002-01-01    | +37242425454 | Description | Narva mnt 27, 51009 Tartu, Estonia | false                   |
            | tahmina@gmail.com  | Taleh2002 | Taleh2002       | Tahmina Taghi | 2002-01-01    | +37242425455 | Description | Narva mnt 25, 51009 Tartu, Estonia | false                   |
        Given the user with email "tahmina@gmail.com" and password "Taleh2002" wants to login
        And the user navigates to login page
        And the user fills login inputs
        And the user clicks login button
        And the user navigates to friend search
        And the user searches "tal"
        And the user clicks the Show Interest button
        And the user navigates to log out
        Given the user with email "taleh958@gmail.com" and password "Taleh2002" wants to login
        And the user navigates to login page
        And the user fills login inputs
        And the user clicks login button
        And the user navigates to friend search
        And the user searches "tah"
        And the user clicks the Accept Interest button
        And the user clicks the View Profile button
        And the user clicks the Message button
        And the user fills message input with Hello
        Then the "Hello" should appear in chat





# ======================================================================================================================================================================================


