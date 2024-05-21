defmodule FriendrWeb.UserIgnoreController do
    use FriendrWeb, :controller

    alias Friendr.Accounts
    alias Friendr.Accounts.User
    alias Friendr.Repo
    alias Friendr.Accounts.UserIgnore
    alias Friendr.Accounts.FriendshipRequest

    def create(conn, %{"ignored_user_id" => ignored_user_id}) do
      current_user = conn.assigns.current_user

      case Accounts.get_user(ignored_user_id) do
        %User{} = ignored_user ->
          changeset = UserIgnore.changeset(%UserIgnore{}, %{ignoring_user_id: current_user.id, ignored_user_id: ignored_user.id})

          case Repo.insert(changeset) do
            {:ok, _ignored_user} ->
              friendship_request = Repo.get_by(FriendshipRequest, sender_id: current_user.id, receiver_id: ignored_user.id)
              if friendship_request do Repo.delete!(friendship_request) end

              conn
              |> json(%{status: "success"})
              |> put_flash(:info, "This user is removed from search")

            {:error, changeset} ->
              conn
              |> put_flash(:error, "Error removing user from search")
              |> redirect(to: ~p"/users/friend_search")
          end
      end
    end

    def check_ignore(conn, %{"ignored_user_id" => ignored_user_id}) do
      current_user = conn.assigns.current_user

      ignored_user =
        Repo.get_by(UserIgnore, ignoring_user_id: current_user.id, ignored_user_id: ignored_user_id)

      case ignored_user do
        nil -> conn |> put_status(200) |> json(%{status: "not_ignored"})
        _ -> conn |> put_status(200) |> json(%{status: "ignored"})
      end
    end
  end
