defmodule FriendrWeb.UserProfileController do
  use FriendrWeb, :controller

  alias Friendr.Accounts
  alias Friendr.Accounts.User
  alias Friendr.Repo
  alias Friendr.Interest
  alias Friendr.Interest.Topic

  def show(conn, _params) do
    user = conn.assigns.current_user

    case Accounts.get_user(user.id) do
      %User{} = user ->
        user_with_associations =
          user
          |> Repo.preload([:interests, :sent_friendship_requests, :received_friendship_requests])
          |> Repo.preload([sent_friendship_requests: [:receiver], received_friendship_requests: [:sender], interests: [:topic]])
        render(conn, "show.html", user: user_with_associations)
    end
  end


  def edit(conn, _params) do
    user = conn.assigns.current_user |> Repo.preload(interests: [:topic])
    topics = Repo.all(Topic)
    changeset = User.changeset(user, %{})
    render(conn, "edit.html", user: user, topics: topics, changeset: changeset)
  end

  def update(conn, %{"user" => user_params, "interests" => interests, "hates" => hates}) do
    user = conn.assigns.current_user
    changeset = User.changeset(user, user_params)

    interests_as_numbers = Enum.map(interests, &String.to_integer/1)
    hates_as_numbers = Enum.map(hates, &String.to_integer/1)

    case have_common_element?(interests_as_numbers, hates_as_numbers) do
      false ->
        Repo.transaction(fn ->
          Repo.delete_all(Interest)

          Enum.map(interests_as_numbers, fn topic_id ->
            Repo.insert(%Interest{
              user_id: user.id,
              topic_id: topic_id,
              relationship: 1
            })
          end)

          Enum.map(hates_as_numbers, fn topic_id ->
            Repo.insert(%Interest{
              user_id: user.id,
              topic_id: topic_id,
              relationship: 0
            })
          end)
        end)

        case Repo.update(changeset) do
          {:ok, _user} ->
            conn
            |> put_flash(:info, "Profile updated successfully")
            |> redirect(to: ~p"/user/profile")
          {:error, changeset} ->
            topics = Repo.all(Topic)

            conn
            |> put_flash(:error, "Failed to update the user.")
            |> render("edit.html", user: user |> Repo.preload(interests: [:topic]), topics: topics, changeset: changeset)
        end
      true ->
        topics = Repo.all(Topic)

        conn
        |> put_flash(:error, "Same topic cannot be both interest and hate.")
        |> render("edit.html", user: user |> Repo.preload(interests: [:topic]), topics: topics, changeset: changeset)
    end

  end

  def have_common_element?(array1, array2) do
    Enum.any?(array1, fn elem1 ->
      Enum.any?(array2, &(&1 == elem1))
    end)
  end

end
