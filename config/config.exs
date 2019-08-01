# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :kritikos,
  ecto_repos: [Kritikos.Repo]

# Configures the endpoint
config :kritikos, KritikosWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ZqlOOOs/G6dbTot3SpxziwEtIkex8K+Yx+VVXM6vVSod/45HPkRj4wVHeeNGdds/",
  render_errors: [view: KritikosWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Kritikos.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configures Guardian
config :kritikos, Kritikos.Auth.Guardian,
  issuer: "kritikos", # Name of your app/company/product
  secret_key: "3a71JsVENIjPNnSmITkDov55BChYIqH2OQK4Q6ri7bWpu4qfdRLdkfHAw6Y3lmr9", #TODO: replace with env var for prod env
  ttl: { 30, :days },
  verify_issuer: true

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
