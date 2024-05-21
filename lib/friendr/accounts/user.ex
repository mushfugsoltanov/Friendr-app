defmodule Friendr.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true, redact: true
    field :hashed_password, :string, redact: true
    field :confirmed_at, :naive_datetime
    field :name, :string
    field :date_of_birth, :date
    field :phone, :string
    field :description, :string
    field :username, :string
    field :location, :string
    field :auto_location_detection, :boolean, default: true
    field :manual_detection, :boolean, default: true
    field :repeat_password, :string, virtual: true
    has_many :interests, Friendr.Interest
    has_many :sent_friendship_requests, Friendr.Accounts.FriendshipRequest, foreign_key: :sender_id
    has_many :received_friendship_requests, Friendr.Accounts.FriendshipRequest, foreign_key: :receiver_id
    many_to_many :related_events, Friendr.Meets.Event, join_through: "user_event"
    has_many :events, Friendr.Meets.Event

    timestamps(type: :utc_datetime)
  end




  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :date_of_birth, :phone, :description, :location, :auto_location_detection, :manual_detection])
    |> validate_name()
    |> validate_date_of_birth()
    |> validate_phone()
    |> validate_location()
  end

  @doc """
  A user changeset for registration.

  It is important to validate the length of both email and password.
  Otherwise databases may truncate the email without warnings, which
  could lead to unpredictable or insecure behaviour. Long passwords may
  also be very expensive to hash for certain algorithms.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.

    * `:validate_email` - Validates the uniqueness of the email, in case
      you don't want to validate the uniqueness of the email (like when
      using this changeset for validations on a LiveView form before
      submitting the form), this option can be set to `false`.
      Defaults to `true`.
  """

def registration_changeset(user, attrs, opts \\ []) do
  user
  |> cast(attrs, [:email, :password, :repeat_password, :name, :date_of_birth, :phone, :description, :location, :auto_location_detection])
  |> validate_email(opts)
  |> validate_password_confirmation()
  |> validate_password(opts)
  |> validate_name()
  |> validate_date_of_birth()
  |> validate_phone()
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

  defp validate_email(changeset, opts) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> maybe_validate_unique_email(opts)
  end

  defp validate_password_confirmation(changeset) do
    password = get_change(changeset, :password)
    repeat_password = get_change(changeset, :repeat_password)

    if is_nil(password) || is_nil(repeat_password) || password != repeat_password do
      changeset
      |> add_error(:repeat_password, "Password and Repeat Password must match")
    else
      changeset
    end
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 8, max: 72)
    # Examples of additional password validation:
    |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/, message: "at least one digit or punctuation character")
    |> maybe_hash_password(opts)
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      # Hashing could be done with `Ecto.Changeset.prepare_changes/2`, but that
      # would keep the database transaction open longer and hurt performance.
      |> put_change(:hashed_password, Pbkdf2.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end

  defp maybe_validate_unique_email(changeset, opts) do
    if Keyword.get(opts, :validate_email, true) do
      changeset
      |> unsafe_validate_unique(:email, Friendr.Repo)
      |> unique_constraint(:email)
    else
      changeset
    end
  end

  defp validate_date_of_birth(changeset) do
    changeset
    |> validate_required([:date_of_birth])
    |> validate_age_constraint()
  end

  defp validate_age_constraint(changeset) do
    case get_change(changeset, :date_of_birth) do
      %Date{} = dob ->
        today = Timex.today()
        age = Timex.diff(today, dob, :years)

        if age < 18 do
          add_error(changeset, :date_of_birth, "must be at least 18 years old")
        else
          changeset
        end

      _ ->
        changeset
    end
  end


  defp validate_name(changeset) do
    changeset
    |> validate_required([:name])
    |> validate_length(:name, min: 3, max: 50, message: "length of name must be between 3 and 50 characters")
    |> validate_format(:name, ~r/^[a-zA-Z\s]+$/, message: "name should only contain letters and whitespace")
  end

  defp validate_phone(changeset) do
    changeset
    |> validate_required([:phone])
    |> validate_format(:phone, ~r/^\+?\d{5,}$/, message: "must be at least 5 digits, optionally with a country code")
  end


  @doc """
  A user changeset for changing the email.

  It requires the email to change otherwise an error is added.
  """
  def email_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:email])
    |> validate_email(opts)
    |> case do
      %{changes: %{email: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :email, "did not change")
    end
  end

  @doc """
  A user changeset for changing the password.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  def password_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:password])
    |> validate_confirmation(:password, message: "does not match password")
    |> validate_password(opts)
  end

  @doc """
  Confirms the account by setting `confirmed_at`.
  """
  def confirm_changeset(user) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    change(user, confirmed_at: now)
  end

  @doc """
  Verifies the password.

  If there is no user or the user doesn't have a password, we call
  `Pbkdf2.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%Friendr.Accounts.User{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Pbkdf2.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Pbkdf2.no_user_verify()
    false
  end

  @doc """
  Validates the current password otherwise adds an error to the changeset.
  """
  def validate_current_password(changeset, password) do
    if valid_password?(changeset.data, password) do
      changeset
    else
      add_error(changeset, :current_password, "is not valid")
    end
  end
end
