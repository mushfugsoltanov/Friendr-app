defmodule Friendr.Accounts.FriendshipRequest do
  use Ecto.Schema
  import Ecto.Changeset

  schema "friendship_requests" do
    field :status, :string, default: "pending"
    belongs_to :sender, Friendr.Accounts.User
    belongs_to :receiver, Friendr.Accounts.User
    timestamps(type: :utc_datetime)
  end


  @doc false
  def changeset(%Friendr.Accounts.FriendshipRequest{} = friendship_request, attrs) do
    friendship_request
    |> cast(attrs, [:status, :sender_id, :receiver_id])
    |> validate_required([:status, :sender_id, :receiver_id])
    |> validate_status()
  end

  defp validate_status(changeset) do
    changeset
    |> validate_inclusion(:status, ["pending", "accepted", "rejected"])
  end
end
