defmodule Friendr.Comment.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :content, :string
    belongs_to :event, Friendr.Meets.Event
    belongs_to :author, Friendr.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(%Friendr.Comment.Comment{} = comment, attrs) do
    comment
    |> cast(attrs, [:content, :author_id, :event_id])
    |> validate_required([:content, :author_id, :event_id])
  end
end
