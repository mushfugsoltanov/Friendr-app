defmodule Friendr.Accounts.UserIgnore do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_ignore" do
    belongs_to :ignoring_user, Friendr.Accounts.User
    belongs_to :ignored_user, Friendr.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(%Friendr.Accounts.UserIgnore{} = user_ignore, attrs) do
    user_ignore
    |> cast(attrs, [:ignoring_user_id, :ignored_user_id])
    |> validate_required([:ignoring_user_id, :ignored_user_id])
  end
end
