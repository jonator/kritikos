# runs after build stage
import Config

config :kritikos, KritikosWeb.Endpoint, secret_key_base: System.fetch_env!("SECRET")
