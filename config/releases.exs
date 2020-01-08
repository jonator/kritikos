import Config

config :kritikos, KritikosWeb.Endpoint, secret_key_base: System.fetch_env!("SECRET")

# Configure your database
config :kritikos, Kritikos.Repo,
  username: "postgres",
  password: "v8KLGz18bxytj78j",
  database: "kritikosdb",
  socket_dir: "/tmp/cloudsql/kritikos-257816:us-central1:kritikos-db",
  pool_size: 15
