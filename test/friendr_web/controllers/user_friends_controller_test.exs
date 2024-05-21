defmodule FriendrWeb.UserFriendsControllerTest do
  use ExUnit.Case
  use FriendrWeb.ConnCase
  alias Friendr.Accounts.User
  alias Friendr.Repo
  alias Friendr.Accounts
  alias Friendr.Accounts.FriendshipRequest
  alias Friendr.Chat.Message


# 3.1. Friends Visualization:
  describe "index/1" do
    @login_data %{email: "sender@gmail.com", password: "Eldaniz1234"}

    test "it returns users that friend with current user", %{conn: conn} do
      {:ok, user_1} = Accounts.register_user(%{
        name: "Sender",
        email: "sender@gmail.com",
        location: "Ülikooli 8a, 51003 Tartu, Estonia",
        description: "Sample Description",
        phone: "1234567890",
        date_of_birth: ~D[1990-01-01],
        password: "Eldaniz1234",
        repeat_password: "Eldaniz1234"
      })

      {:ok, user_2} = Accounts.register_user(%{
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

      conn =
        conn
        |> post("/friendship_request", %{"receiver_id" => Integer.to_string(user_2.id)})

      friendship_request = Accounts.get_friendship_request(user_1.id, user_2.id)

      conn =
        conn
        |> post("/friendship_request/accept", %{"request_id" => Integer.to_string(friendship_request.id)})


      conn = get(conn, "/users/friends")
      conn = get(conn, "/users/friends", %{"search_text" => "Receiver"})
      assert html_response(conn, 200)
      assert String.contains?(conn.resp_body, "Receiver")
    end
  end

# 3.2. Friends Filtering:
  describe "show/3" do
    @login_data %{email: "sender@gmail.com", password: "Eldaniz1234"}
    test "view friend by search", %{conn: conn} do
      {:ok, user_1} = Accounts.register_user(%{
        name: "Sender",
        email: "sender@gmail.com",
        location: "Ülikooli 8a, 51003 Tartu, Estonia",
        description: "Sample Description",
        phone: "1234567890",
        date_of_birth: ~D[1990-01-01],
        password: "Eldaniz1234",
        repeat_password: "Eldaniz1234"
      })

      {:ok, user_2} = Accounts.register_user(%{
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

      conn =
        conn
        |> post("/friendship_request", %{"receiver_id" => Integer.to_string(user_2.id)})

      friendship_request = Accounts.get_friendship_request(user_1.id, user_2.id)

      conn =
        conn
        |> post("/friendship_request/accept", %{"request_id" => Integer.to_string(friendship_request.id)})


      conn = get(conn, "/users/friends")
      conn = get(conn, "/users/friends", %{"search_text" => "Receiver"})
      assert String.contains?(conn.resp_body, "Receiver")

    end
  end


# 3.3. Friends Details:
  describe "show/2" do
    @login_data %{email: "sender@gmail.com", password: "Eldaniz1234"}
    test "view friend profile", %{conn: conn} do
      {:ok, user_1} = Accounts.register_user(%{
        name: "Sender",
        email: "sender@gmail.com",
        location: "Ülikooli 8a, 51003 Tartu, Estonia",
        description: "Sample Description",
        phone: "1234567890",
        date_of_birth: ~D[1990-01-01],
        password: "Eldaniz1234",
        repeat_password: "Eldaniz1234"
      })

      {:ok, user_2} = Accounts.register_user(%{
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

      conn =
        conn
        |> post("/friendship_request", %{"receiver_id" => Integer.to_string(user_2.id)})

      friendship_request = Accounts.get_friendship_request(user_1.id, user_2.id)

      conn =
        conn
        |> post("/friendship_request/accept", %{"request_id" => Integer.to_string(friendship_request.id)})


      conn = get(conn, "/users/friends")
      conn = get(conn, "/users/friends", %{"search_text" => "Receiver"})

            case conn.assigns.users do
              [%{"id" => user_id} | _] ->
                conn = get(conn, "/users/user/#{user_id}")

                assert html_response(conn, 200)
                assert String.contains?(conn.resp_body, "UserB")

              [] ->
                assert html_response(conn, 200)
                assert String.contains?(conn.resp_body, "No friend found")

              _ ->
                assert false
            end

    end
  end

# 3.4. Unfriend:
  describe "unfriend/2" do
    @login_data %{email: "sender@gmail.com", password: "Eldaniz1234"}

    test "unfriend friend", %{conn: conn} do
      {:ok, user_1} = Accounts.register_user(%{
        name: "Sender",
        email: "sender@gmail.com",
        location: "Ülikooli 8a, 51003 Tartu, Estonia",
        description: "Sample Description",
        phone: "1234567890",
        date_of_birth: ~D[1990-01-01],
        password: "Eldaniz1234",
        repeat_password: "Eldaniz1234"
      })

      {:ok, user_2} = Accounts.register_user(%{
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

      conn =
        conn
        |> post("/friendship_request", %{"receiver_id" => Integer.to_string(user_2.id)})

      friendship_request = Accounts.get_friendship_request(user_1.id, user_2.id)

      conn =
        conn
        |> post("/friendship_request/accept", %{"request_id" => Integer.to_string(friendship_request.id)})

      conn =
        conn
        |> post("/friendship_request/decline", %{"request_id" => Integer.to_string(friendship_request.id)})

      conn = get(conn, "/users/friends")
      conn = get(conn, "/users/friends", %{"search_text" => "Receiver"})
      assert html_response(conn, 200)
      assert String.contains?(conn.resp_body, "No friend found")
    end
  end






  # 3.5. Friends Chat:
  describe "meassage/2" do
  @login_data %{email: "sender@gmail.com", password: "Eldaniz1234"}

  test "Sends a message", %{conn: conn} do
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

    friendship_data = %{
      status: "accepted",
      sender_id: sender.id,
      receiver_id: receiver.id,
    }
    friendship_changeset = FriendshipRequest.changeset(%FriendshipRequest{}, friendship_data)
    Repo.insert(friendship_changeset)

    conn = post(conn, "/users/log_in", user: @login_data)

    conn = conn |> post("/chat/#{receiver.id}", %{"message" => "Hello, Eldaniz!"})

    message_result = hd(Repo.all(Message)).content

    assert json_response(conn, 200)["status"] == "success"
    assert message_result == "Hello, Eldaniz!"
  end

  test "Reads all the messages", %{conn: conn} do
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

    friendship_data = %{
      status: "accepted",
      sender_id: sender.id,
      receiver_id: receiver.id,
    }
    friendship_changeset = FriendshipRequest.changeset(%FriendshipRequest{}, friendship_data)
    Repo.insert(friendship_changeset)

    conn = post(conn, "/users/log_in", user: @login_data)

    conn = conn |> post("/chat/#{receiver.id}", %{"message" => "Hello, Eldaniz!"})
    conn = conn |> post("/chat/#{receiver.id}", %{"message" => "Hello!"})

    conn = conn |> get("/chat/#{receiver.id}")

    assert String.contains?(conn.resp_body, "Hello, Eldaniz!")
    assert String.contains?(conn.resp_body, "Hello!")

  end
  end
end
