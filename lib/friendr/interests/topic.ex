defmodule Friendr.Interest.Topic do
  use Ecto.Schema
  import Ecto.Changeset

  schema "topics" do
    field :name, :string
    many_to_many :events, Friendr.Meets.Event, join_through: "event_topic"
  end

  def changeset(topic, attrs \\ %{}) do
    topic
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
