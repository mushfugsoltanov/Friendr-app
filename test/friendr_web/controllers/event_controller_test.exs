defmodule FriendrWeb.EventControllerTest do
  use ExUnit.Case
  use FriendrWeb.ConnCase
  alias Friendr.Accounts.User
  alias Friendr.Repo
  alias Friendr.Accounts



# 4.1. Event Organization:
  describe "create/4" do
    @login_data %{ email: "taleh@mail.com", password: "Taleh2002" }

    @event_data %{
      name: "test event",
      date: "2002-01-01T00:00:00Z",
      description: "Sample Description",
      location: "Ülikooli 8a, 51003 Tartu, Estonia",
      is_public: true,
      price: 0,
    }

    test "test creates an event", %{conn: conn} do
      {:ok, user_data} = Accounts.register_user(%{
        email: "taleh@mail.com",
        password: "Taleh2002",
        repeat_password: "Taleh2002",
        name: "Taleh Taghi",
        date_of_birth: Date.from_iso8601!("2002-01-01"),
        phone: "+37242546763",
        description: "I am a student of UT and TalTech",
        location: "Narva mnt 27, 51009 Tartu, Estonia",
      })

      conn = post(conn, "/users/log_in", user: @login_data)

      event_data_with_user_id = Map.put(@event_data, :user_id, user_data.id)

      conn = post(conn, "/events", %{"event" => event_data_with_user_id, "topics" => [], "event_list" => ""})

      assert get_flash(conn, :info) == "Event created successfully."
    end
  end


  # 4.4. Future Events Search:
  describe "index/2" do
    @login_data %{ email: "taleh@mail.com", password: "Taleh2002" }

    @event_data %{
      name: "test event",
      date: "2002-01-01T00:00:00Z",
      description: "Sample Description",
      location: "Ülikooli 8a, 51003 Tartu, Estonia",
      is_public: true,
      price: 0,
    }

    test "test search event", %{conn: conn} do
      {:ok, user_data} = Accounts.register_user(%{
        email: "taleh@mail.com",
        password: "Taleh2002",
        repeat_password: "Taleh2002",
        name: "Taleh Taghi",
        date_of_birth: Date.from_iso8601!("2002-01-01"),
        phone: "+37242546763",
        description: "I am a student of UT and TalTech",
        location: "Narva mnt 27, 51009 Tartu, Estonia",
      })

      conn = post(conn, "/users/log_in", user: @login_data)

      event_data_with_user_id = Map.put(@event_data, :user_id, user_data.id)

      conn = post(conn, "/events", %{"event" => event_data_with_user_id, "topics" => [], "event_list" => ""})
      conn = get(conn, "/events", %{"search_text" => "test"})

      assert String.contains?(conn.resp_body, "test event")
    end
  end


  # 4.2. Event Visibility:
  describe "visibility/1" do
    @login_data %{ email: "taleh@mail.com", password: "Taleh2002" }

    @event_data %{
      name: "test event",
      date: "2002-01-01T00:00:00Z",
      description: "Sample Description",
      location: "Ülikooli 8a, 51003 Tartu, Estonia",
      is_public: true,
      price: 0,
    }

    test "test event visibility", %{conn: conn} do
      {:ok, user_data} = Accounts.register_user(%{
        email: "taleh@mail.com",
        password: "Taleh2002",
        repeat_password: "Taleh2002",
        name: "Taleh Taghi",
        date_of_birth: Date.from_iso8601!("2002-01-01"),
        phone: "+37242546763",
        description: "I am a student of UT and TalTech",
        location: "Narva mnt 27, 51009 Tartu, Estonia",
      })

      conn = post(conn, "/users/log_in", user: @login_data)

      event_data_with_user_id = Map.put(@event_data, :user_id, user_data.id)

      conn = post(conn, "/events", %{"event" => event_data_with_user_id, "topics" => [], "event_list" => ""})

      conn = get(conn, "/events")

      assert String.contains?(conn.resp_body, "Public")
    end
  end



# 4.7. Created Events Search:
  describe "my events/1" do
    @login_data %{ email: "taleh@mail.com", password: "Taleh2002" }

    @event_data %{
      name: "test event",
      date: "2002-01-01T00:00:00Z",
      description: "Sample Description",
      location: "Ülikooli 8a, 51003 Tartu, Estonia",
      is_public: true,
      price: 0,
    }

    test "test my events", %{conn: conn} do
      {:ok, user_data} = Accounts.register_user(%{
        email: "taleh@mail.com",
        password: "Taleh2002",
        repeat_password: "Taleh2002",
        name: "Taleh Taghi",
        date_of_birth: Date.from_iso8601!("2002-01-01"),
        phone: "+37242546763",
        description: "I am a student of UT and TalTech",
        location: "Narva mnt 27, 51009 Tartu, Estonia",
      })

      conn = post(conn, "/users/log_in", user: @login_data)

      event_data_with_user_id = Map.put(@event_data, :user_id, user_data.id)

      conn = post(conn, "/events", %{"event" => event_data_with_user_id, "topics" => [], "event_list" => ""})

      conn = get(conn, "/my_events")

      assert String.contains?(conn.resp_body, "test event")
    end
  end



  # 4.8. Event Lists Operations:  
  describe "event operations/1" do
    @login_data %{ email: "taleh@mail.com", password: "Taleh2002" }

    @event_data %{
      name: "test event",
      date: "2002-01-01T00:00:00Z",
      description: "Sample Description",
      location: "Ülikooli 8a, 51003 Tartu, Estonia",
      is_public: true,
      price: 0,
    }

    test "test event operations", %{conn: conn} do
      {:ok, user_data} = Accounts.register_user(%{
        email: "taleh@mail.com",
        password: "Taleh2002",
        repeat_password: "Taleh2002",
        name: "Taleh Taghi",
        date_of_birth: Date.from_iso8601!("2002-01-01"),
        phone: "+37242546763",
        description: "I am a student of UT and TalTech",
        location: "Narva mnt 27, 51009 Tartu, Estonia",
      })

      conn = post(conn, "/users/log_in", user: @login_data)

      event_data_with_user_id = Map.put(@event_data, :user_id, user_data.id)

      conn = post(conn, "/events", %{"event" => event_data_with_user_id, "topics" => [], "event_list" => ""})

      conn = get(conn, "/events")

      assert String.contains?(conn.resp_body, "Edit")
      assert String.contains?(conn.resp_body, "Delete")
    end
  end
end
