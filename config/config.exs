# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :koueki,
  ecto_repos: [Koueki.Repo]

# Configures the endpoint
config :koueki, KouekiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "+LGZBul1cu5cH5sbwv/DqyVyWP+Bqcb2xItoCIoOLK0p/JiM2cYgt4yCKUyzSsC5",
  render_errors: [view: KouekiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Koueki.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger,
  backends: [:console, {LoggerFileBackend, :error_log}]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :logger, :error_log,
  path: "logs/koueki.log",
  level: :info

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :koueki, :instance,
  name: "Koueki",
  signup_enabled: true,
  sync_frequency: 60_000 * 1

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
