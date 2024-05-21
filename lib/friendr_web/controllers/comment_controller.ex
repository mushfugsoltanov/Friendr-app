defmodule FriendrWeb.CommentController do
  use FriendrWeb, :controller

  alias Friendr.Comment.Comment
  alias Friendr.Meets.Event
  alias Friendr.Repo

  def create(conn, %{"event_id" => event_id, "comment" => comment}) do
    current_user = conn.assigns.current_user
    event = Repo.get(Event, event_id)

    case event do
      %Event{} ->
        changeset = Comment.changeset(%Comment{}, %{content: comment, author_id: current_user.id, event_id: event.id})

        case Repo.insert(changeset) do
          {:ok, _comment} ->
            conn |> json(%{status: "success"})
          {:error, changeset} ->
            conn |> put_flash(:error, "Error posting comment")
        end

      _ -> conn |> put_flash(:error, "Event with this id is not found")
    end
  end
end
