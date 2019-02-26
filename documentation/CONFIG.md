# Configuration

All configuration is done in the `config/` directory.

Create the file `config/prod.secret.exs` with the following template,
adjust credentials as you require.

If you're using the docker-compose installation method, your database
hostname will be `postgres`. The default postgres credentials can be
found in the `docker-compose.yml` file.

```elixir
use Mix.Config

config :koueki, Koueki.Repo,
  username: "koueki",
  password: "your_db_password",
  database: "koueki_prod",
  hostname: "localhost",
  pool_size: 10

config :koueki, :instance,
  name: "My Koueki",
  signup_enabled: true
```

All keys should be relatively self-explanatory.

