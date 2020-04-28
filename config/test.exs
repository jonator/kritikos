import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :kritikos, KritikosWeb.Endpoint,
  secret_key_base: "ZqlOOOs/G6dbTot3SpxziwEtIkex8K+Yx+VVXM6vVSod/45HPkRj4wVHeeNGdds/",
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :kritikos, Kritikos.Repo,
  username: "postgres",
  password: "postgres",
  database: "kritikos_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :bcrypt_elixir, log_rounds: 4
