defmodule Friendr.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :string
      add :date, :naive_datetime
      add :location, :string
      add :price, :decimal
      add :description, :text
      add :is_public, :boolean, default: true
      add :user_id, references(:users)

      timestamps(type: :utc_datetime)
    end
  end
end
