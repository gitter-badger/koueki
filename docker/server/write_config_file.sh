cat > /koueki/config/prod.secret.exs <<EOF
use Mix.Config

config :koueki, Koueki.Repo,
  username: "$POSTGRES_USER",
  password: "$POSTGRES_HOST",
  database: "koueki_prod",
  hostname: "$POSTGRES_HOST",
  pool_size: 10

config :koueki, :instance,
  name: "My Koueki",
  signup_enabled: true
EOF
