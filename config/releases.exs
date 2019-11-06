import Config

config :kritikos, KritikosWeb.Endpoint, secret_key_base: System.fetch_env!("SECRET")

# Configure your database
config :kritikos, Kritikos.Repo,
  username: System.fetch_env!("PGUSER"),
  password: System.fetch_env!("PGPASSWORD"),
  database: System.fetch_env!("PGDATABASE"),
  host: System.fetch_env!("PGHOST"),
  pool_size: 15

config :kritikos, Kritikos.Auth.Authenticator,
  seed: "user token",
  secret: System.fetch_env!("SECRET")
