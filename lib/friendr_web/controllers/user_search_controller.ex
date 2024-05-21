defmodule FriendrWeb.UserSearchController do
  use FriendrWeb, :controller

  alias Friendr.Accounts
  alias Friendr.Accounts.User
  alias Friendr.Repo
  alias Friendr.Accounts.UserIgnore

  import Ecto.Query

  def index(conn, %{"search_text" => search_text} = _params) do
    current_user = conn.assigns.current_user
    changeset = User.changeset(%User{}, %{name: search_text})

    users =
      if is_binary(search_text) and String.trim(search_text) != "" do
        users =
          from(
            u in User,
            left_join: ui in UserIgnore, on: u.id == ui.ignored_user_id and ui.ignoring_user_id == ^current_user.id,
            where: ilike(u.name, ^"#{search_text}%") and is_nil(ui.id)
          )
          |> Repo.all()
      else
        from(
          u in User,
          left_join: ui in UserIgnore, on: u.id == ui.ignored_user_id and ui.ignoring_user_id == ^current_user.id,
          where: is_nil(ui.id)
        )
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
        user.distance <= 10 # Change '10' to the desired distance threshold
      end)
      |> Enum.sort_by(fn user ->
        user.distance
      end)

      user_with_associations =
        nearby_users
        |> Enum.map(&Repo.preload(&1, [:sent_friendship_requests, :received_friendship_requests]))
        |> Enum.map(&Repo.preload(&1, [sent_friendship_requests: [:receiver], received_friendship_requests: [:sender]]))

    render(conn, "index.html", users: user_with_associations, search_text: search_text, changeset: changeset, current_user: current_user)
  end

  def index(conn, _params) do
    current_user = conn.assigns.current_user
    changeset = User.changeset(current_user, %{})

    users = from(
              u in User,
              left_join: ui in UserIgnore, on: u.id == ui.ignored_user_id and ui.ignoring_user_id == ^current_user.id,
              where: is_nil(ui.id)
            )
            |> Repo.all()

    nearby_users =
      users
      |> Enum.map(fn user ->
        user_location = user.location
        distance = Friendr.Geolocation.distance(current_user.location, user_location)
        Map.put(user, :distance, distance)
      end)
      |> Enum.filter(fn user ->
        user.distance <= 10 # Change '10' to the desired distance threshold
      end)
      |> Enum.sort_by(fn user ->
        user.distance
      end)

    user_with_associations =
      nearby_users
      |> Enum.map(&Repo.preload(&1, [:sent_friendship_requests, :received_friendship_requests]))
      |> Enum.map(&Repo.preload(&1, [sent_friendship_requests: [:receiver], received_friendship_requests: [:sender]]))

    render(conn, "index.html", users: user_with_associations, search_text: nil, changeset: changeset, current_user: current_user)
  end

  def update_location(conn, %{"user" => user_params}) do
    user = conn.assigns.current_user
    changeset = User.changeset(user, user_params)
    Repo.update(changeset)

    case Repo.update(changeset) do
      {:ok, _user} ->
        conn
       |> put_flash(:info, "Your location updated successfully")
       |> redirect(to: ~p"/users/friend_search")

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Failed to update the user location.")
        |> render("index.html", user: user, changeset: changeset, search_text: nil, users: [])
      end
  end


  def show(conn, %{"id" => id}) do
    current_user = conn.assigns.current_user
    id_int = String.to_integer(id)

    if id_int == current_user.id do
      conn
      |> redirect(to: ~p"/user/profile")
    end
    case Accounts.get_user(id) do
      %User{} = user ->
        user_with_associations =
          user
          |> Repo.preload([:interests, :sent_friendship_requests, :received_friendship_requests])
          |> Repo.preload([sent_friendship_requests: [:receiver], received_friendship_requests: [:sender], interests: [:topic]])
        render(conn, "show.html", user: user_with_associations)
    end
  end


end
