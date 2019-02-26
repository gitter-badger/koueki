ln -s /var/run/secrets/config /koueki/config/prod.secret.exs

mix ecto.create
mix ecto.migrate
mix phx.server
