defmodule Friendr.Repo.Migrations.CreateInterests do
  use Ecto.Migration

  def change do
    create table(:interests) do
      add :relationship, :integer, check: "relationship = 0 OR relationship = 1"
      add :topic_id, references(:topics)
      add :user_id, references(:users)

      timestamps()
    end

    create unique_index(:interests, [:topic_id, :user_id])
  end
end
