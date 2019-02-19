defmodule Koueki.Repo do
  use Ecto.Repo,
    otp_app: :koueki,
    adapter: Ecto.Adapters.Postgres
end
