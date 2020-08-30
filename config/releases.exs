# runs after build stage
import Config

config :kritikos, KritikosWeb.Endpoint, secret_key_base: System.fetch_env!("SECRET")

config :kritikos, Kritikos.Repo,
  username: "postgres",
  password: System.fetch_env!("POSTGRES_PASSWORD"),
  database: "kritikosdb",
  hostname: "db",
  pool_size: 15

config :kritikos, KritikosWeb.Mailer,
  adapter: Bamboo.MailgunAdapter,
  api_key: System.fetch_env!("MAILGUN_API_KEY"),
  domain: "kritikos.app"

config :stripity_stripe, api_key: System.get_env("STRIPE_API_KEY")
