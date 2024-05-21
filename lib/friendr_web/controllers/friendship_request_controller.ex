
defmodule FriendrWeb.FriendshipRequestController do
  use FriendrWeb, :controller

  alias Friendr.Accounts
  alias Friendr.Accounts.User
  alias Friendr.Repo
  alias Friendr.Accounts.FriendshipRequest
  alias Friendr.Accounts.UserIgnore

  def create(conn, %{"receiver_id" => receiver_id}) do
    current_user = conn.assigns.current_user

    case Accounts.get_user(receiver_id) do
      %User{} = receiver ->
        changeset = FriendshipRequest.changeset(%FriendshipRequest{}, %{sender_id: current_user.id, receiver_id: receiver.id})

        case Repo.insert(changeset) do
          {:ok, _friendship_request} ->
            user_ignore = Repo.get_by(UserIgnore, ignoring_user_id: current_user.id, ignored_user_id: receiver.id)
            if user_ignore do Repo.delete!(user_ignore) end

            conn
            |> json(%{status: "success"})
            |> put_flash(:info, "Friendship request sent")

          {:error, changeset} ->
            conn
            |> put_flash(:error, "Error sending friendship request")
            |> redirect(to: ~p"/users/friend_search")
        end
    end
  end

  def check_status(conn, %{"receiver_id" => receiver_id}) do
    current_user = conn.assigns.current_user

    friendship_request =
      Repo.get_by(FriendshipRequest, sender_id: current_user.id, receiver_id: receiver_id)

    accept_friendship_request =
      Repo.get_by(FriendshipRequest, sender_id: receiver_id, receiver_id: current_user.id)

    case {friendship_request, accept_friendship_request} do
      {nil, nil} ->
        conn |> put_status(200) |> json(%{status: "not_requested"})
      {_, nil} ->
        if friendship_request.status == "accepted" do
          conn |> put_status(200) |> json(%{status: "friend"})
        else
          conn |> put_status(200) |> json(%{status: "requested"})
        end
      {nil, _} ->
        if accept_friendship_request.status == "accepted" do
          conn |> put_status(200) |> json(%{status: "friend"})
        else
          conn |> put_status(200) |> json(%{status: "accept_requested"})
        end
    end
  end

  def accept(conn, %{"request_id" => request_id}) do
    case conn.assigns.current_user do
      %User{id: user_id} ->
        handle_accept(conn, user_id, request_id)

      _ ->
        conn
        |> put_status(401)
        |> json(%{error: "Unauthorized"})
    end
  end

  defp handle_accept(conn, user_id, request_id) do
    case Repo.get(FriendshipRequest, request_id) do
      nil ->
        conn
        |> put_status(404)
        |> json(%{error: "Friendship request not found"})

      %FriendshipRequest{receiver_id: user_id, status: "pending"} = friendship_request ->
        updated_request = friendship_request
        |> Ecto.Changeset.change(%{status: "accepted"})
        |> Repo.update()

        conn
        |> put_status(200)
        |> json(%{status: "success"})

      _ ->
        conn
        |> put_status(403)
        |> json(%{error: "Unauthorized"})
    end
  end

  def decline(conn, %{"request_id" => request_id}) do

    case conn.assigns.current_user do
      %User{id: user_id} ->
        handle_decline(conn, user_id, request_id)

      _ ->
        conn
        |> put_status(401)
        |> json(%{error: "Unauthorized"})
    end
  end

  defp handle_decline(conn, user_id, request_id) do
    case Repo.get(FriendshipRequest, request_id) do
      nil ->
        conn
        |> put_status(404)
        |> json(%{error: "Friendship request not found"})

      %FriendshipRequest{receiver_id: user_id} = friendship_request ->
        Repo.delete(friendship_request)

        conn
        |> put_status(200)
        |> json(%{status: "success"})

      _ ->
        conn
        |> put_status(403)
        |> json(%{error: "Unauthorized"})
    end
  end








end
