# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :kritikos,
  ecto_repos: [Kritikos.Repo]

# Configures the endpoint
config :kritikos, KritikosWeb.Endpoint,
  render_errors: [view: KritikosWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Kritikos.PubSub, adapter: Phoenix.PubSub.PG2]

config :kritikos, Kritikos.Sessions.KeywordFactory,
  keyword_file_path: "./priv/static/session_keywords.txt"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ecto_sql, :migration_module, Ecto.Migration

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
