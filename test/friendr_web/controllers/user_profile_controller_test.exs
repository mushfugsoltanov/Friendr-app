defmodule FriendrWeb.UserProfileControllerTest do
  use ExUnit.Case
  use FriendrWeb.ConnCase

  alias FriendrWeb.UserProfileController
  alias Friendr.Accounts.User
  alias Friendr.Interest.Topic
  alias Friendr.Interest
  alias Friendr.Repo

  import Ecto.Query
  
# 1.3. User Interests and Hates:
  describe "have_common_element?/2" do
    test "returns true if arrays have common elements" do
      array1 = [1, 2, 3]
      array2 = [3, 4, 5]

      result = UserProfileController.have_common_element?(array1, array2)

      assert result == true
    end

    test "returns false if arrays have no common elements" do
      array1 = [1, 2, 3]
      array2 = [4, 5, 6]

      result = UserProfileController.have_common_element?(array1, array2)

      assert result == false
    end
  end

  describe "update/1" do
    @user_data %{
      email: "taleh@mail.com",
      password: "Taleh2002",
      repeat_password: "Taleh2002",
      name: "Taleh Taghi",
      date_of_birth: Date.from_iso8601!("2002-01-01"),
      phone: "+37242546763",
      description: "I am a student of UT and TalTech",
      location: "Narva mnt 27, 51009 Tartu, Estonia",
    }
    @login_data %{ email: "taleh@mail.com", password: "Taleh2002" }

    test "updates user profile with valid data", %{conn: conn} do
      conn = post(conn, "/users/register", user: @user_data)
      conn = post(conn, "/users/log_in", user: @login_data)

      largest_topic_id =
        case Repo.all(from(t in Topic, order_by: [desc: t.id])) do
          [] -> 0
          all_topics -> hd(all_topics).id
        end

      topics = [
        %{id: largest_topic_id+1, name: "Topic 1"},
        %{id: largest_topic_id+2, name: "Topic 2"},
        %{id: largest_topic_id+3, name: "Topic 3"},
        %{id: largest_topic_id+4, name: "Topic 4"},
        %{id: largest_topic_id+5, name: "Topic 5"}
      ]
      Repo.insert_all(Topic, topics)

      params = %{name: "Updated Name"}
      interests = [to_string(largest_topic_id+1), to_string(largest_topic_id+2), to_string(largest_topic_id+3)]
      hates = [to_string(largest_topic_id+4), to_string(largest_topic_id+5)]

      conn = put(conn, "/user/profile", %{"user" => params, "interests" => interests, "hates" => hates})

      user_result = Repo.get(User, conn.assigns.current_user.id)
      interests_result = Repo.all(from(i in Interest, where: i.relationship == 1))
      hates_result = Repo.all(from(i in Interest, where: i.relationship == 0))

      assert user_result.name == "Updated Name"
      assert length(interests_result) == 3
      assert length(hates_result) == 2
      assert redirected_to(conn) == "/user/profile"
      assert get_flash(conn, :info) == "Profile updated successfully"
    end

    test "fails with error when common element exists between interests and hates", %{conn: conn} do
      conn = post(conn, "/users/register", user: @user_data)
      conn = post(conn, "/users/log_in", user: @login_data)

      largest_topic_id =
        case Repo.all(from(t in Topic, order_by: [desc: t.id])) do
          [] -> 0
          all_topics -> hd(all_topics).id
        end

      topics = [
        %{id: largest_topic_id+1, name: "Topic 1"},
        %{id: largest_topic_id+2, name: "Topic 2"},
        %{id: largest_topic_id+3, name: "Topic 3"},
        %{id: largest_topic_id+4, name: "Topic 4"},
        %{id: largest_topic_id+5, name: "Topic 5"}
      ]
      Repo.insert_all(Topic, topics)

      params = %{name: "New Name"}
      interests = [to_string(largest_topic_id+1), to_string(largest_topic_id+2), to_string(largest_topic_id+3)]
      hates = [to_string(largest_topic_id+4), to_string(largest_topic_id+3)]

      conn = put(conn, "/user/profile", %{"user" => params, "interests" => interests, "hates" => hates})

      user_result = Repo.get(User, conn.assigns.current_user.id)

      assert user_result.name == "Taleh Taghi"
      assert get_flash(conn, :error) == "Same topic cannot be both interest and hate."
    end
  end
end
