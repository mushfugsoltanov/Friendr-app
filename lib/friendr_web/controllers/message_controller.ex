defmodule FriendrWeb.MessageController do
  use FriendrWeb, :controller

  alias Friendr.Chat.Message
  alias Friendr.Accounts
  alias Friendr.Accounts.FriendshipRequest
  alias Friendr.Accounts.User
  alias Friendr.Repo

  import Ecto.Query

  def index(conn, %{"id" => id}) do
    current_user = conn.assigns.current_user
    interlocutor = Accounts.get_user(id)

    case interlocutor do
      %User{} ->
        friendship =
          from(
            fr in FriendshipRequest,
            join: u in User,
            on: (u.id == fr.sender_id and fr.receiver_id == ^current_user.id and fr.sender_id == ^interlocutor.id)
                or (u.id == fr.receiver_id and fr.sender_id == ^current_user.id and fr.receiver_id == ^interlocutor.id),
            where: fr.status == "accepted"
          ) |> Repo.one()

        case friendship do
          %FriendshipRequest{} ->
            messages =
              Repo.all(from m in Message,
                where: (
                  (m.receiver_id == ^current_user.id and m.sender_id == ^interlocutor.id) or
                  (m.receiver_id == ^interlocutor.id and m.sender_id == ^current_user.id)
                ),
                select: m
              )

            render(conn, "index.html", messages: messages, interlocutor: interlocutor)

          _ -> conn |> put_flash(:error, "User with this id is not friend with current user")
        end

      _ -> conn |> put_flash(:error, "User with this id is not found")
    end
  end

  def create(conn, %{"receiver_id" => receiver_id, "message" => message}) do
    current_user = conn.assigns.current_user
    interlocutor = Accounts.get_user(receiver_id)

    case interlocutor do
      %User{} ->
        friendship =
          from(
            fr in FriendshipRequest,
            join: u in User,
            on: (u.id == fr.sender_id and fr.receiver_id == ^current_user.id and fr.sender_id == ^interlocutor.id)
                or (u.id == fr.receiver_id and fr.sender_id == ^current_user.id and fr.receiver_id == ^interlocutor.id),
            where: fr.status == "accepted"
          ) |> Repo.one()
         case friendship do
          %FriendshipRequest{} ->
            changeset = Message.changeset(%Message{}, %{content: message, sender_id: current_user.id, receiver_id: interlocutor.id})

            case Repo.insert(changeset) do
              {:ok, _friendship_request} ->
                conn |> json(%{status: "success"})
              {:error, changeset} ->
                conn |> put_flash(:error, "Error sending message")
            end

          _ -> conn |> put_flash(:error, "User with this id is not friend with current user")
        end

      _ -> conn |> put_flash(:error, "User with this id is not found")
    end
  end
end
