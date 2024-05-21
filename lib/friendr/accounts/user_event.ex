defmodule Friendr.Accounts.UserEvent do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_event" do
    field :status, :integer
    belongs_to :user, Friendr.Accounts.User
    belongs_to :event, Friendr.Meets.Event

    timestamps(type: :utc_datetime)
  end


  @doc false
  def changeset(user_event, attrs) do
    user_event
    |> cast(attrs, [:status, :user_id, :event_id])
    |> validate_status()
    |> validate_required([:status, :user_id, :event_id])
  end

  defp validate_status(changeset) do
    validate_change(changeset, :status, fn _, status ->
      if Enum.member?([0, 1, 2], status) do
        changeset
      else
        add_error(changeset, :status, "must be 0, 1, or 2")
      end
    end)
  end
end
