defmodule FriendrWeb.UserRegistrationControllerTest do
  use ExUnit.Case
  use FriendrWeb.ConnCase
  alias Friendr.Accounts.User
  alias Friendr.Repo
  alias Friendr.Accounts

# 1.1. User Self-Registration:
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
    test "user self registration", %{conn: conn} do
      conn = post(conn, "/users/register", user: @user_1_data)
      conn = get(conn, "/")
      assert html_response(conn, 200)
      assert get_flash(conn, :info) == "User created successfully."
    end
  end

# 1.4. Automatic User Location:
describe "index/3" do
  @login_data %{email: "sender@gmail.com", password: "Eldaniz1234"}
  test "manual location", %{conn: conn} do
    {:ok, user_1} = Accounts.register_user(%{
      name: "Sender",
      email: "sender@gmail.com",
      location: "Ülikooli 8a, 51003 Tartu, Estonia",
      description: "Sample Description",
      phone: "1234567890",
      date_of_birth: ~D[1990-01-01],
      password: "Eldaniz1234",
      repeat_password: "Eldaniz1234",
      auto_location_detection: true
    })
    conn = post(conn, "/users/log_in", user: @login_data)
    conn = get(conn, "/user/profile")
    assert html_response(conn, 200)
    assert String.contains?(conn.resp_body, "Ülikooli 8a, 51003 Tartu, Estonia")
  end
end

# 1.5. Manual User Location:
  describe "index/2" do
    @login_data %{email: "sender@gmail.com", password: "Eldaniz1234"}
    test "manual location", %{conn: conn} do
      {:ok, user_1} = Accounts.register_user(%{
        name: "Sender",
        email: "sender@gmail.com",
        location: "Ülikooli 8a, 51003 Tartu, Estonia",
        description: "Sample Description",
        phone: "1234567890",
        date_of_birth: ~D[1990-01-01],
        password: "Eldaniz1234",
        repeat_password: "Eldaniz1234",
        auto_location_detection: false
      })
      conn = post(conn, "/users/log_in", user: @login_data)
      conn = get(conn, "/user/profile")
      assert html_response(conn, 200)
      assert String.contains?(conn.resp_body, "Ülikooli 8a, 51003 Tartu, Estonia")
    end
  end

end
