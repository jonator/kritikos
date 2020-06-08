import Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with webpack to recompile .js and .css sources.
config :kritikos, KritikosWeb.Endpoint,
  url: [scheme: "http://", host: "localhost:4000", port: 4000],
  secret_key_base: "ZqlOOOs/G6dbTot3SpxziwEtIkex8K+Yx+VVXM6vVSod/45HPkRj4wVHeeNGdds/",
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch-stdin",
      cd: Path.expand("../assets", __DIR__)
    ]
  ],
  live_reload: [
    # Watch static and templates for browser reloading.
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/kritikos_web/views/.*(ex)$},
      ~r{lib/kritikos_web/templates/.*(eex)$}
    ]
  ],
  live_view: [signing_salt: "SECRET_SALT"]

config :kritikos, KritikosWeb.Mailer, adapter: Bamboo.LocalAdapter

config :stripity_stripe,
  public_key: "pk_test_fLfgIeP1l56Kg3lS3A82wKns00XdANMFHO",
  api_key: "sk_test_BJrOyM75cSB4JdeKdDV3bnbt00gWQB9idX"

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

# Configure your database
config :kritikos, Kritikos.Repo,
  username: "postgres",
  password: "postgres",
  database: "kritikos_db",
  hostname: "localhost",
  pool_size: 10
