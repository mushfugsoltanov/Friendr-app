defmodule Friendr.Meets.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :name, :string
    field :date, :naive_datetime
    field :description, :string
    field :location, :string
    field :price, :decimal
    field :is_public, :boolean, default: true
    many_to_many :topics, Friendr.Interest.Topic, join_through: "event_topic"
    many_to_many :users, Friendr.Accounts.User, join_through: "user_event"
    has_many :comments, Friendr.Comment.Comment
    belongs_to :user, Friendr.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :date, :location, :price, :description, :is_public, :user_id])
    |> validate_required([:name, :date, :location, :price, :description, :is_public, :user_id])
    |> validate_length(:name, min: 2, max: 100)
    |> validate_length(:description, min: 10, max: 500)
    |> validate_number(:price, greater_than_or_equal_to: 0)
    |> validate_location()
  end

  defp validate_location(changeset) do
    location = get_change(changeset, :location) || get_field(changeset, :location)

    if is_nil(location) or location == "" do
      add_error(changeset, :location, "Location is required")
    else
      case Friendr.Geolocation.address_valid(location) do
        true -> changeset
        false ->
          add_error(changeset, :location, "The entered address is invalid or in the wrong format.")
      end
    end
  end

end
