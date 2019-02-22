defmodule Koueki.Repo do
  use Ecto.Repo,
    otp_app: :koueki,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 20
end
