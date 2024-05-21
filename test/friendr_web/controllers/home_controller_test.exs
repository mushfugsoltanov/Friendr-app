defmodule FriendrWeb.HomeControllerTest do
  use ExUnit.Case
  use FriendrWeb.ConnCase
  alias Friendr.Accounts.User
  alias Friendr.Repo
  alias Friendr.Accounts

# 5.1. Links to Event Searches:
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
    test "links to event searches", %{conn: conn} do
      conn = post(conn, "/users/register", user: @user_1_data)
      conn = get(conn, "/")
      assert html_response(conn, 200)
      conn = get(conn, "/events")
      assert String.contains?(conn.resp_body, "Events")
    end
  end


# 5.2. Link to Friends List:
  describe "index/2" do
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
    test "link to friend search", %{conn: conn} do
      conn = post(conn, "/users/register", user: @user_1_data)
      conn = get(conn, "/")
      assert html_response(conn, 200)
      conn = get(conn, "/users/friends")
      assert String.contains?(conn.resp_body, "Search for Friends")
    end
  end


# 5.3. Link to Potential Friends:
describe "index/3" do
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
  test "link to potential friends", %{conn: conn} do
    conn = post(conn, "/users/register", user: @user_1_data)
    conn = get(conn, "/")
    assert html_response(conn, 200)
    conn = get(conn, "/users/friend_search")
    assert String.contains?(conn.resp_body, "Search for Potential Friends")
  end
end

end
