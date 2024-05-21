defmodule FriendrWeb.UserSessionControllerTest do
  use ExUnit.Case
  use FriendrWeb.ConnCase
  alias Friendr.Accounts.User
  alias Friendr.Repo
  alias Friendr.Accounts

# 1.2. User authentication/authorization:
  describe "index/1" do
    @login_data %{email: "sender@gmail.com", password: "Eldaniz1234"}
    test "user registration", %{conn: conn} do
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
      conn = post(conn, "/users/log_in", user: @login_data)
      conn = get(conn, "/user/profile")
      assert html_response(conn, 200)
      assert String.contains?(conn.resp_body, "Sender")
    end
  end
end
