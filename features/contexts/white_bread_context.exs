  defmodule WhiteBreadContext do
    use WhiteBread.Context
    use Hound.Helpers

    alias Friendr.{Repo, Accounts.User}

    feature_starting_state fn  ->
      Application.ensure_all_started(:hound)
      %{}
    end

    scenario_starting_state fn state ->
      Hound.start_session
      Ecto.Adapters.SQL.Sandbox.checkout(Friendr.Repo)
      Ecto.Adapters.SQL.Sandbox.mode(Friendr.Repo, {:shared, self()})
      %{}
    end

    scenario_finalize fn _status, state ->
      Ecto.Adapters.SQL.Sandbox.checkin(Friendr.Repo)
      Hound.end_session
    end

    and_ ~r/^the user navigates to the registration page$/, fn state ->
      navigate_to "/users/register"
      {:ok, state}
    end

    and_ ~r/^the user fills in the registration form with valid details$/, fn state ->

      user= %{
        email: "taleh98@gmail.com",
        password: "Taleh2002",
        repeat_password: "Taleh2002",
        name: "Taleh Taghi",
        date_of_birth: "01/01/2000",
        phone: "+37242425454",
        description: "Description",
        auto_location_detection: true
      }
      fill_field({:id, "input_email"}, user.email)
      fill_field({:id, "input_password"}, user.password)
      fill_field({:id, "input_repeat_password"}, user.repeat_password)
      fill_field({:id, "input_name"}, user.name)
      fill_field({:id, "input_date_of_birth"}, user.date_of_birth)
      fill_field({:id, "input_phone"}, user.phone)
      fill_field({:id, "input_description"}, user.description)
      click({:id, "auto_location"})
      :timer.sleep(3000)
      click({:id, "register_button"})
      {:ok, state}
    end

    when_ ~r/^the user fills in the registration form with invalid details$/, fn state ->
      {:ok, state}

      user= %{
        email: "taleh98@gmail.com",
        password: "Taleh2001",
        repeat_password: "Taleh2",
        name: "Taleh Taghi",
        date_of_birth: "01/01/2000",
        phone: "+37242425454",
        description: "Description",
        auto_location_detection: false
      }
      fill_field({:id, "input_email"}, user.email)
      fill_field({:id, "input_password"}, user.password)
      fill_field({:id, "input_repeat_password"}, user.repeat_password)
      fill_field({:id, "input_name"}, user.name)
      fill_field({:id, "input_date_of_birth"}, user.date_of_birth)
      fill_field({:id, "input_phone"}, user.phone)
      fill_field({:id, "input_description"}, user.description)
      click({:id, "auto_location"})
      :timer.sleep(3000)
      click({:id, "register_button"})
      {:ok, state}
    end

    then_ ~r/^the system should display an error message$/, fn state ->
      assert visible_in_page? ~r/ something went wrong/
      {:ok, state}
    end

    then_ ~r/^the user should be successfully logged out$/, fn state ->
      assert visible_in_page? ~r/Logged out successfully./
      {:ok, state}
    end

    and_ ~r/^the user should remain on the registration page$/, fn state ->
      assert visible_in_page? ~r/Register for an account/
    {:ok, state}
  end

    and_ ~r/^the user edit his-her location manually$/, fn state ->

      user= %{
        location: "Narva mnt 10, 51009 Tartu, Estonia",
      }
      click({:id, "interests_1"})
      click({:id, "hates_2"})
      click({:id, "manual_location"})
      fill_field({:id, "location_field"}, user.location)
      {:ok, state}
    end

    and_ ~r/^the user fills in the event form with valid details$/, fn state ->

      event= %{
        name: "Happy New Year Party",
        date: "12/12/2040T12:01PM+02:00",
        price: 20,
        description: "Happy New Year Party",
        location: "Narva mnt 10, 51009 Tartu, Estonia",
      }
      fill_field({:id, "input_name"}, event.name)
      fill_field({:id, "input_date"}, event.date)
      click({:id, "manual_location"})
      fill_field({:id, "location_field"}, event.location)
      fill_field({:id, "input_price"}, event.price)
      fill_field({:id, "input_desciption"}, event.description)
      click({:id, "topic_1"})
      :timer.sleep(3000)
      click({:id, "save_button"})
      :timer.sleep(3000)
      {:ok, state}
    end

    and_ ~r/^the user fills in the event form as private$/, fn state ->

      event= %{
        name: "Happy New Year Party",
        date: "12/12/2023T12:01PM+02:00",
        price: 20,
        description: "Happy New Year Party",
        location: "Narva mnt 10, 51009 Tartu, Estonia",
        email: "tahmina@gmail.com"
      }
      fill_field({:id, "input_name"}, event.name)
      fill_field({:id, "input_date"}, event.date)
      click({:id, "manual_location"})
      fill_field({:id, "location_field"}, event.location)
      fill_field({:id, "input_price"}, event.price)
      fill_field({:id, "input_desciption"}, event.description)
      click({:id, "is_public"})
      fill_field({:id, "privateEventEmailsInput"}, event.email)
      click({:id, "topic_1"})
      :timer.sleep(3000)
      click({:id, "save_button"})
      :timer.sleep(3000)
      {:ok, state}
    end


    and_ ~r/^the user choose a Topic$/, fn state ->
      click({:id, "topic_filter_Politics"})
      {:ok, state}
    end

    and_ ~r/^the user enter start and end dates$/, fn state ->
      start_date = "10/10/2020T12:01PM+02:00"
      end_date = "12/15/2044T12:01PM+02:00"
      fill_field({:id, "dateFilterStart"}, start_date)
      fill_field({:id, "dateFilterEnd"}, end_date)
      {:ok, state}
    end

    and_ ~r/^the user will successfully see event with in that date range$/, fn state ->
      assert visible_in_page? ~r/Happy New Year Party/
      {:ok, state}
    end

    and_ ~r/^the user will successfully see event with that topic$/, fn state ->
      assert visible_in_page? ~r/Happy New Year Party/
      {:ok, state}
    end



    and_ ~r/^the user searches "(?<search_text>[^"]+)" in events list$/, fn state, %{search_text: search_text} ->
      fill_field({:id, "event_search_input"}, search_text)
      click({:id, "event_search_button"})
      {:ok, state}
    end

    and_ ~r/^the user will successfully see that event$/, fn state ->
      assert visible_in_page? ~r/Happy New Year Party/
      {:ok, state}
    end

    and_ ~r/^the user will successfully see his-her created events$/, fn state ->
      assert visible_in_page? ~r/Happy New Year Party/
      {:ok, state}
    end

    and_ ~r/^the user will successfully see Upcoming Event$/, fn state ->
      assert visible_in_page? ~r/Happy New Year Party/
      {:ok, state}
    end



    and_ ~r/^the user will successfully create event$/, fn state ->
      assert visible_in_page? ~r/Event created successfully./
      {:ok, state}
    end

    and_ ~r/^the user should be successfully registered$/, fn state ->
      assert visible_in_page? ~r/User created successfully./
      {:ok, state}
    end

    then_ ~r/^the user should be successfully logged in$/, fn state ->
      assert visible_in_page? ~r/Welcome/
      {:ok, state}
    end

    given_ ~r/^the following users are registered$/, fn state, %{table_data: table} ->
      table
      |> Enum.map(fn user -> User.registration_changeset(%User{}, user) end)
      |> Enum.each(fn changeset -> Repo.insert!(changeset) end)
      {:ok, state}
    end

    given_ ~r/^the user with email "(?<email>[^"]+)" and password "(?<password>[^"]+)" wants to login$/,
      fn state, %{email: email, password: password} ->
        # Insert login logic here if needed
        {:ok, state |> Map.put(:email, email) |> Map.put(:password, password)}
    end


    and_ ~r/^the user navigates to login page$/, fn state ->
      navigate_to "/users/log_in"
      {:ok, state}
    end

    and_ ~r/^the user navigates to settings page$/, fn state ->
      navigate_to "/users/settings"
      {:ok, state}
    end

    then_ ~r/^the user should see success message about change password$/, fn state ->
      assert visible_in_page? ~r/Password updated successfully./
      {:ok, state}
    end

    and_ ~r/^the user fills change password inputs$/, fn state ->
      new_password = "Qwer1234"
      confirm_password = "Qwer1234"
      current_password = "Taleh2002"
      :timer.sleep(3000)
      fill_field({:id, "update_password_password"}, new_password)
      fill_field({:id, "confirm_password"}, confirm_password)
      fill_field({:id, "current_password_for_password"}, current_password)
      click({:id, "change_pass"})
      {:ok, state}
    end

    and_ ~r/^the user fills login inputs$/, fn state ->
      fill_field({:id, "input_email"}, state[:email])
      fill_field({:id, "input_password"}, state[:password])
      {:ok, state}
    end

    and_ ~r/^the user navigates to log out$/, fn state ->
      click({:id, "log-out"})
      {:ok, state}
    end

    and_ ~r/^the user navigates to log out after log in$/, fn state ->
      click({:id, "flash_x"})
      click({:id, "log-out"})
      {:ok, state}
    end

    and_ ~r/^the user clicks login button$/, fn state ->
      click({:id, "sign_in_button"})
      {:ok, state}
    end

    and_ ~r/^the user navigates to friend search$/, fn state ->
      click({:id, "search-friends"})
      {:ok, state}
    end

    and_ ~r/^the user navigates to my profile page without login$/, fn state ->
      navigate_to "/user/profile"
      {:ok, state}
    end

    and_ ~r/^the user navigates to home page$/, fn state ->
      navigate_to "/"
      {:ok, state}
    end

    and_ ~r/^the user clicks on Events button$/, fn state ->
      click({:id, "events"})
      {:ok, state}
    end

    and_ ~r/^the user should see Events Search in that page$/, fn state ->
      assert visible_in_page? ~r/Search for Events/
      {:ok, state}
    end

    and_ ~r/^the user clicks on Friends button$/, fn state ->
      click({:id, "friends"})
      {:ok, state}
    end

    and_ ~r/^the user should see Friend List in that page$/, fn state ->
      assert visible_in_page? ~r/Friend List/
      {:ok, state}
    end

    and_ ~r/^the user clicks on Potential Friends button$/, fn state ->
      click({:id, "search-friends"})
      {:ok, state}
    end

    and_ ~r/^the user clicks Reset Password button$/, fn state ->
      click({:id, "reset-pas"})
      {:ok, state}
    end

    and_ ~r/^the user fills email input$/, fn state ->
      user = %{email: "taleh958@gmail.com"}
      fill_field({:id, "reset_email"}, user.email)
      click({:id, "reset_send"})
      {:ok, state}
    end

    and_ ~r/^the user should see successfull message$/, fn state ->
      assert visible_in_page? ~r/If your email is in our system, you will receive instructions to reset your password shortly./
      {:ok, state}
    end


    and_ ~r/^the user should see Potential Friends in that page$/, fn state ->
      assert visible_in_page? ~r/Potential Friends/
      {:ok, state}
    end



    and_ ~r/^the user will see You must log in to access this page.$/, fn state ->
      assert visible_in_page? ~r/You must log in to access this page./
      {:ok, state}
    end


    and_ ~r/^the user navigates to my profile page$/, fn state ->
      navigate_to "/user/profile"
      {:ok, state}
    end

    and_ ~r/^the user see his-her information$/, fn state ->
      assert visible_in_page? ~r/User Profile/
      {:ok, state}
    end

    and_ ~r/^the user clicks edit button$/, fn state ->
      click({:id, "edit-button"})
      {:ok, state}
    end

    and_ ~r/^the user fills topic inputs$/, fn state ->
      click({:id, "interests_1"})
      click({:id, "hates_2"})
      {:ok, state}
    end

    and_ ~r/^the user clicks save button$/, fn state ->
      click({:id, "save"})
      {:ok, state}
    end
    and_ ~r/^the user should see his-her updated information$/, fn state ->
      assert visible_in_page? ~r/Interests: Politics/
      assert visible_in_page? ~r/Hates: Sports/
      {:ok, state}
    end

    and_ ~r/^the user should see his-her updated location$/, fn state ->
      assert visible_in_page? ~r/Location: Narva mnt 10, 51009 Tartu, Estonia/
      {:ok, state}
    end

    and_ ~r/^the user see successfully update location$/, fn state ->
      :timer.sleep(3000)
      assert visible_in_page? ~r/Your location updated successfully/
      :timer.sleep(3000)
      {:ok, state}
    end


    and_ ~r/^the user should see his-her interests and hates$/, fn state ->
      assert visible_in_page? ~r/Interests: Politics/
      assert visible_in_page? ~r/Hates: Sports/
      {:ok, state}
    end

    and_ ~r/^the user navigates to friends list$/, fn state ->
      navigate_to "/users/friends"

      {:ok, state}
    end

    and_ ~r/^the user will see Tahmina Taghi in the friends list$/, fn state ->
      :timer.sleep(3000)
      assert visible_in_page? ~r/Tahmina Taghi/
      {:ok, state}
    end

    and_ ~r/^the user navigates to events page$/, fn state ->
      navigate_to "/events"
      {:ok, state}
    end

    and_ ~r/^the user navigates to my events page$/, fn state ->
      navigate_to "/my_events"
      {:ok, state}
    end

    then_ ~r/^the user clicks New Event button$/, fn state ->
      click({:id, "new-event"})
      {:ok, state}
    end

    then_ ~r/^the user clicks the Message button$/, fn state ->
      click({:id, "message"})
      {:ok, state}
    end

    and_ ~r/^the user fills message input with Hello word$/, fn state ->
      message = "Hello"
      fill_field({:id, "input-comment"}, message)
      click({:id, "button-message"})
      :timer.sleep(3000)
      {:ok, state}
    end

     and_ ~r/^the user fills message input with Hello$/, fn state ->
      message = "Hello"
      fill_field({:id, "input-message"}, message)
      click({:id, "button-message"})
      :timer.sleep(3000)
      {:ok, state}
    end

    then_ ~r/^the "Hello" should appear in chat$/, fn state ->
      assert visible_in_page? ~r/Hello/
      {:ok, state}
    end

    and_ ~r/^the user searches "(?<search_text>[^"]+)" in friends list$/, fn state, %{search_text: search_text} ->
      fill_field({:id, "user_search_input"}, search_text)
      click({:id, "user_search_button"})
      {:ok, state}
    end

    and_ ~r/^the user searches "(?<search_text>[^"]+)"$/, fn state, %{search_text: search_text} ->
      fill_field({:id, "user_search_input"}, search_text)
      click({:id, "user_search_button"})
      {:ok, state}
    end

    then_ ~r/^the user clicks the search button$/, fn state ->
      click({:id, "user_search_button"})
      :timer.sleep(3000)
      {:ok, state}
    end

    and_ ~r/^the user will see Tahmina Taghi before Eldaniz Akbar in the search results$/, fn state ->
    assert visible_in_page? ~r/Tahmina Taghi/
    assert visible_in_page? ~r/Eldaniz Akbar/
    {:ok, state}
    end

    then_ ~r/^the user clicks the Ignore button$/, fn state ->
      click({:id, "ignore-button"})
      :timer.sleep(3000)
      {:ok, state}
    end


    and_ ~r/^the user should see No users found in the search results$/, fn state ->
      :timer.sleep(3000)
      assert visible_in_page? ~r/No users found/
      {:ok, state}
    end

    and_ ~r/^the user should see No events found in the search results$/, fn state ->
      :timer.sleep(3000)
      assert visible_in_page? ~r/No events found/
      {:ok, state}
    end

    and_ ~r/^the user clicks any Event$/, fn state ->
      click({:id, "row_0"})
      {:ok, state}
    end

    and_ ~r/^the user will see Tahmina Taghi in the search results$/, fn state ->
      assert visible_in_page? ~r/Tahmina Taghi/
      {:ok, state}
    end

    when_ ~r/^the user clicks the View Profile button$/, fn state ->
      click({:id, "view-profile-button"})
      {:ok, state}
    end

    then_ ~r/^the user should be navigated to the details page of another user$/, fn state ->
      assert visible_in_page? ~r/User Profile/
      {:ok, state}
    end

    then_ ~r/^the user should be navigated to the profile page of the friend$/, fn state ->
      assert visible_in_page? ~r/Friend/
      {:ok, state}
    end

    when_ ~r/^the user clicks the Show Interest button$/, fn state ->
      :timer.sleep(3000)
      click({:id, "interested-button"})
      {:ok, state}
    end

    then_ ~r/^the button should be renamed to Interested$/, fn state ->
      assert visible_in_page? ~r/Interested/
      {:ok, state}
    end

    when_ ~r/^the user clicks the Accept Interest button$/, fn state ->
      click({:id, "interested-button"})
      {:ok, state}
    end

    then_ ~r/^the button should be renamed to Friend$/, fn state ->
      assert visible_in_page? ~r/Friend/
      {:ok, state}
    end

    when_ ~r/^the user clicks the Unfriend button$/, fn state ->
      click({:id, "unfriend-button"})
      {:ok, state}
    end

    then_ ~r/^the user will not see "(?<search_text>[^"]+)" in friends list$/, fn state, %{search_text: search_text} ->
      assert not visible_in_page? ~r/search_text/
      {:ok, state}
    end
  end
