defmodule Kritikos.Repo do
  use Ecto.Repo,
    otp_app: :kritikos,
    adapter: Ecto.Adapters.Postgres
end
