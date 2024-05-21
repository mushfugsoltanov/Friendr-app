defmodule FriendrWeb.UserFriendsController do
  use FriendrWeb, :controller

  alias Friendr.Accounts
  alias Friendr.Accounts.User
  alias Friendr.Repo
  alias Friendr.Accounts.UserIgnore
  alias Friendr.Accounts.FriendshipRequest

  import Ecto.Query

  def index(conn, %{"search_text" => search_text} = _params) do
    current_user = conn.assigns.current_user
    changeset = User.changeset(%User{}, %{name: search_text})

    friends_query =
      from u in User,
        join: fr in FriendshipRequest,
        on: (u.id == fr.sender_id and fr.receiver_id == ^current_user.id) or (u.id == fr.receiver_id and fr.sender_id == ^current_user.id),
        where: fr.status == "accepted"

    users =
      if String.trim(search_text) != "" do
        users =
          from(
            u in friends_query,
            where: ilike(u.name, ^"#{search_text}%")
          )
          |> Repo.all()
      else
        friends_query
        |> Repo.all()
      end

    nearby_users =
      users
      |> Enum.map(fn user ->
        user_location = user.location
        distance = Friendr.Geolocation.distance(current_user.location, user_location)
        Map.put(user, :distance, distance)
      end)
      |> Enum.filter(fn user ->
        user.distance != nil
      end)
      |> Enum.sort_by(fn user ->
        user.distance
      end)

    user_with_associations =
      nearby_users
      |> Enum.map(&Repo.preload(&1, [:sent_friendship_requests, :received_friendship_requests]))
      |> Enum.map(&Repo.preload(&1, [sent_friendship_requests: [:receiver], received_friendship_requests: [:sender]]))

    render(conn, "index.html", users: user_with_associations, search_text: search_text, changeset: changeset)
  end

  def index(conn, _params) do
    current_user = conn.assigns.current_user
    friends_query =
      from u in User,
        join: fr in FriendshipRequest,
        on: (u.id == fr.sender_id and fr.receiver_id == ^current_user.id) or (u.id == fr.receiver_id and fr.sender_id == ^current_user.id),
        where: fr.status == "accepted"

    users =
      friends_query
      |> Repo.all()

    nearby_users =
      users
      |> Enum.map(fn user ->
        user_location = user.location
        distance = Friendr.Geolocation.distance(current_user.location, user_location)
        Map.put(user, :distance, distance)
      end)
      |> Enum.filter(fn user ->
        user.distance != nil
      end)
      |> Enum.sort_by(fn user ->
        user.distance
      end)

    user_with_associations =
      nearby_users
      |> Enum.map(&Repo.preload(&1, [:sent_friendship_requests, :received_friendship_requests]))
      |> Enum.map(&Repo.preload(&1, [sent_friendship_requests: [:receiver], received_friendship_requests: [:sender]]))

    render(conn, "index.html", users: user_with_associations, search_text: "Friend List")
  end

end
