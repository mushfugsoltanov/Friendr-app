defmodule FriendrWeb.UserSearchControllerTest do
  use ExUnit.Case
  use FriendrWeb.ConnCase
  alias Friendr.Accounts.User
  alias Friendr.Repo
  alias Friendr.Accounts


# 2.1. Potential Friend Search:
  describe "index/1" do
    @user_1_data %{
      email: "taleh@mail.com",
      password: "Taleh2002",
      repeat_password: "Taleh2002",
      name: "Taleh Taghi",
      date_of_birth: Date.from_iso8601!("2002-01-01"),
      phone: "+37242546763",
      description: "I am a student of UT and TalTech",
      location: "Narva mnt 27, 51009 Tartu, Estonia",
    }
    @user_2_data %{
      email: "tahmina@mail.com",
      password: "Tahmina1995",
      repeat_password: "Tahmina1995",
      name: "Tahmina Taghi",
      date_of_birth: Date.from_iso8601!("1995-01-01"),
      phone: "+37242546702",
      description: "I am a student of UT and TalTech",
      location: "Narva mnt 25, 51009 Tartu, Estonia",
    }
    @login_data %{ email: "taleh@mail.com", password: "Taleh2002" }

    test "it returns nearby users when search_text is provided", %{conn: conn} do
      conn = post(conn, "/users/register", user: @user_1_data)
      conn = post(conn, "/users/register", user: @user_2_data)
      conn = post(conn, "/users/log_in", user: @login_data)

      conn = get(conn, "/users/friend_search", %{"search_text" => "tah"})

      assert html_response(conn, 200)
      assert String.contains?(conn.resp_body, "Search results for \"tah\"")
    end
  end


# 2.2. Potential Friend Sorting:
describe "index/2" do
  @user_3_data %{
    email: "john_doe@mail.com",
    password: "JohnDoe123",
    repeat_password: "JohnDoe123",
    name: "Tohn Doe",
    date_of_birth: Date.from_iso8601!("1985-05-15"),
    phone: "+37255554444",
    description: "I love coding!",
    location: "Narva mnt 3, 51009 Tartu, Estonia",
  }
  @login_data %{ email: "taleh@mail.com", password: "Taleh2002" }

  test "it sorts nearby users by ascending distance", %{conn: conn} do
    conn = post(conn, "/users/register", user: @user_1_data)
    conn = post(conn, "/users/register", user: @user_2_data)
    conn = post(conn, "/users/register", user: @user_3_data)
    conn = post(conn, "/users/log_in", user: @login_data)

    conn = get(conn, "/users/friend_search", %{"search_text" => "t"})
    assert html_response(conn, 200)

    case conn.assigns.users do
      [%{"id" => user_id_2} | [%{"id" => user_id_3} | _]] ->
          assert html_response(conn, 200)
          assert String.contains?(conn.resp_body, "Tahmina")
          assert String.contains?(conn.resp_body, "Tohn")
      [] ->
          assert html_response(conn, 200)
          assert String.contains?(conn.resp_body, "No users found")

        _ ->
          assert false
    end
  end
end


# 2.3. Potential Friends Details:
  describe "show/2" do
    test "view potential friend details", %{conn: conn} do
      user_1_data = %{
        email: "mushfug@gmail.com",
        password: "Mushfugelixir11",
        repeat_password: "Mushfugelixir11",
        name: "Mushfug",
        date_of_birth: Date.from_iso8601!("2001-11-09"),
        phone: "37255667788",
        description: "here is elixir",
        location: "Narva mnt 20, 51009 Tartu, Estonia",
      }

      user_2_data = %{
        email: "mursal@mail.com",
        password: "Mursal123",
        repeat_password: "Mursal123",
        name: "Mursal",
        date_of_birth: Date.from_iso8601!("2000-12-01"),
        phone: "+37299887766",
        description: "hello, I am Mursal",
        location: "Narva mnt 27b, 51009 Tartu, Estonia",
      }

      conn = post(conn, "/users/register", user: user_1_data)
      conn = post(conn, "/users/register", user: user_2_data)
      conn = post(conn, "/users/log_in", user: %{"email" => "mushfug@gmail.com", "password" => "Mushfugelixir11"})

      conn = get(conn, "/users/friend_search", %{"search_text" => "Mursal123"})

      case conn.assigns.users do
        [%{"id" => user_id} | _] ->
          conn = get(conn, "/users/user/#{user_id}")

          assert html_response(conn, 200)
          assert String.contains?(conn.resp_body, "Mursal123")
          assert String.contains?(conn.resp_body, "hello, I am Mursal")
          assert String.contains?(conn.resp_body, "2000-12-01")
          assert String.contains?(conn.resp_body, "+37299887766")
          assert String.contains?(conn.resp_body, "Narva mnt 27b, 51009 Tartu, Estonia")

        [] ->
          assert html_response(conn, 200)
          assert String.contains?(conn.resp_body, "No users found")

        _ ->
          assert false
      end
    end
  end



# 2.4. Potential Friends Deletion:
  describe "delete/2" do
    test "view potential friend details", %{conn: conn} do
      user_1_data = %{
        email: "mushfug@gmail.com",
        password: "Mushfugelixir11",
        repeat_password: "Mushfugelixir11",
        name: "Mushfug",
        date_of_birth: Date.from_iso8601!("2001-11-09"),
        phone: "37255667788",
        description: "here is elixir",
        location: "Narva mnt 20, 51009 Tartu, Estonia",
      }

      user_2_data = %{
        email: "mursal@mail.com",
        password: "Mursal123",
        repeat_password: "Mursal123",
        name: "Mursal",
        date_of_birth: Date.from_iso8601!("2000-12-01"),
        phone: "+37299887766",
        description: "hello, I am Mursal",
        location: "Narva mnt 27b, 51009 Tartu, Estonia",
      }

      conn = post(conn, "/users/register", user: user_1_data)
      conn = post(conn, "/users/register", user: user_2_data)
      conn = post(conn, "/users/log_in", user: %{"email" => "mushfug@gmail.com", "password" => "Mushfugelixir11"})

      conn = get(conn, "/users/friend_search", %{"search_text" => "Mursal123"})

      case conn.assigns.users do
        [%{"id" => user_id} | _] ->
          conn = post(conn, "users/user_ignore")

        [] ->
          assert html_response(conn, 200)
          assert String.contains?(conn.resp_body, "No users found")

        _ ->
          assert false


        assert not String.contains?(conn.resp_body, "Mursal123")
      end
    end
  end


# 2.5. Friend Requests:
  describe "request/1" do
  @login_data %{email: "sender@gmail.com", password: "Eldaniz1234"}
  test "creates a friendship request", %{conn: conn}  do
    {:ok, sender} = Accounts.register_user(%{
      name: "Sender",
      email: "sender@gmail.com",
      location: "Ülikooli 8a, 51003 Tartu, Estonia",
      description: "Sample Description",
      phone: "1234567890",
      date_of_birth: ~D[1990-01-01],
      password: "Eldaniz1234",
      repeat_password: "Eldaniz1234"
    })

    {:ok, receiver} = Accounts.register_user(%{
      name: "Receiver",
      email: "receiver@gmail.com",
      location: "Ülikooli 8a, 51003 Tartu, Estonia",
      description: "Sample Description",
      phone: "1234567890",
      date_of_birth: ~D[1990-01-01],
      password: "Eldaniz1234",
      repeat_password: "Eldaniz1234"
    })

    conn = post(conn, "/users/log_in", user: @login_data)

    assert nil == Accounts.get_friendship_request(sender.id, receiver.id)


    conn =
      conn
      |> post("/friendship_request", %{"receiver_id" => Integer.to_string(receiver.id)})

    friend_request_after_send = Accounts.get_friendship_request(sender.id, receiver.id)
    assert friend_request_after_send.status == "pending"
  end

end


test "accept the friendship request", %{conn: conn}  do
  {:ok, sender} = Accounts.register_user(%{
    name: "Sender",
    email: "sender@gmail.com",
    location: "Ülikooli 8a, 51003 Tartu, Estonia",
    description: "Sample Description",
    phone: "1234567890",
    date_of_birth: ~D[1990-01-01],
    password: "Eldaniz1234",
    repeat_password: "Eldaniz1234"
  })

  {:ok, receiver} = Accounts.register_user(%{
    name: "Receiver",
    email: "receiver@gmail.com",
    location: "Ülikooli 8a, 51003 Tartu, Estonia",
    description: "Sample Description",
    phone: "1234567890",
    date_of_birth: ~D[1990-01-01],
    password: "Eldaniz1234",
    repeat_password: "Eldaniz1234"
  })

  conn = post(conn, "/users/log_in", user: @login_data)
  # Send a friendship request
  conn =
    conn
    |> post("/friendship_request", %{"receiver_id" => Integer.to_string(receiver.id)})

  # Respond to the friendship request by accepting
  friendship_request = Accounts.get_friendship_request(sender.id, receiver.id)

  conn =
    conn
    |> post("/friendship_request/accept", %{"request_id" => Integer.to_string(friendship_request.id)})


  friendship_request_after_accept = Accounts.get_friendship_request(sender.id, receiver.id)
  assert friendship_request_after_accept.status == "accepted"
end

test "decline the friendship request", %{conn: conn}  do
  {:ok, sender} = Accounts.register_user(%{
    name: "Sender",
    email: "sender@gmail.com",
    location: "Ülikooli 8a, 51003 Tartu, Estonia",
    description: "Sample Description",
    phone: "1234567890",
    date_of_birth: ~D[1990-01-01],
    password: "Eldaniz1234",
    repeat_password: "Eldaniz1234"
  })

  {:ok, receiver} = Accounts.register_user(%{
    name: "Receiver",
    email: "receiver@gmail.com",
    location: "Ülikooli 8a, 51003 Tartu, Estonia",
    description: "Sample Description",
    phone: "1234567890",
    date_of_birth: ~D[1990-01-01],
    password: "Eldaniz1234",
    repeat_password: "Eldaniz1234"
  })

  conn = post(conn, "/users/log_in", user: @login_data)
  # Send a friendship request
  conn =
    conn
    |> post("/friendship_request", %{"receiver_id" => Integer.to_string(receiver.id)})

  # Respond to the friendship request by declining

  friendship_request = Accounts.get_friendship_request(sender.id, receiver.id)

  conn =
    conn
    |> post("/friendship_request/decline", %{"request_id" => Integer.to_string(friendship_request.id)})


  friendship_request_after_accept = Accounts.get_friendship_request(sender.id, receiver.id)
  assert friendship_request_after_accept == nil
end


end
