defmodule Friendr.Repo.Migrations.CreateEventTopic do
  use Ecto.Migration

  def change do
    create table(:event_topic) do
      add :topic_id, references(:topics, on_delete: :delete_all)
      add :event_id, references(:events, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end
  end
end
