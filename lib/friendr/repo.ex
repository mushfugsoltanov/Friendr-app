defmodule Friendr.Repo do
  use Ecto.Repo,
    otp_app: :friendr,
    adapter: Ecto.Adapters.Postgres
end
