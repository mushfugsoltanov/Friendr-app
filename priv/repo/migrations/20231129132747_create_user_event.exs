defmodule Friendr.Repo.Migrations.CreateUserEvent do
  use Ecto.Migration

  def change do
    create table(:user_event) do
      add :status, :integer
      add :user_id, references(:users, on_delete: :delete_all)
      add :event_id, references(:events, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    execute("ALTER TABLE user_event ADD CONSTRAINT check_status CHECK (status = 0 OR status = 1 OR status = 2)")
  end
end
