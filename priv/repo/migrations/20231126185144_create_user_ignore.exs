defmodule Friendr.Repo.Migrations.CreateUserIgnore do
  use Ecto.Migration

  def change do
    create table(:user_ignore) do
      add :ignoring_user_id, references(:users, on_delete: :delete_all), null: false
      add :ignored_user_id, references(:users, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:user_ignore, [:ignoring_user_id, :ignored_user_id], unique: true)
  end
end
