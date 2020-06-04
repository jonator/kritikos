# runs after build stage
import Config

config :kritikos, KritikosWeb.Endpoint, secret_key_base: System.fetch_env!("SECRET")

config :kritikos, Kritikos.Repo,
  username: "postgres",
  password: System.fetch_env!("DB_PASS"),
  database: "kritikosdb",
  socket_dir: "/tmp/cloudsql/kritikos-257816:us-central1:kritikos-db",
  pool_size: 15

config :kritikos, Kritikos.Mailer,
  adapter: Bamboo.MailgunAdapter,
  api_key: System.fetch_env!("MAILGUN_API_KEY"),
  domain: "kritikos.app"

config :stripity_stripe, api_key: System.get_env("STRIPE_API_KEY")
