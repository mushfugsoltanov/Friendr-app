defmodule Friendr.Repo.Migrations.CreateFriendshipRequests do
  use Ecto.Migration

  def change do
    create table(:friendship_requests) do
      add :status, :string, default: "pending"
      add :sender_id, references(:users, on_delete: :delete_all), null: false
      add :receiver_id, references(:users, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:friendship_requests, [:sender_id, :receiver_id], unique: true)
  end
end
