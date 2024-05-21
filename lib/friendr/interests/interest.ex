defmodule Friendr.Interest do
  use Ecto.Schema
  import Ecto.Changeset

  schema "interests" do
    field :relationship, :integer
    belongs_to :topic, Friendr.Interest.Topic
    belongs_to :user, Friendr.Accounts.User

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:relationship])
    |> validate_required([:relationship])
    |> validate_enum(:relationship, [0, 1])
  end

  defp validate_enum(changeset, field, allowed_values) do
    value = get_field(changeset, field)

    if value in allowed_values do
      changeset
    else
      add_error(changeset, field, "must be one of #{Enum.join(allowed_values, ", ")}")
    end
  end
end
