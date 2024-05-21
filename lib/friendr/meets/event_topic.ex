defmodule Friendr.Meets.EventTopic do
  use Ecto.Schema
  import Ecto.Changeset

  schema "event_topic" do
    belongs_to :topic, Friendr.Interest.Topic
    belongs_to :event, Friendr.Events.Event

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(event_topic, attrs) do
    event_topic
    |> cast(attrs, [:topic_id, :event_id])
    |> validate_required([:topic_id, :event_id])
  end
end
