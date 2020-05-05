import Config

# For production, don't forget to configure the url host
# to something meaningful, Phoenix uses this information
# when generating URLs.
#
# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix phx.digest` task,
# which you should run after static files are built and
# before starting your production server.
config :kritikos,
  default_release: :kritikos

config :kritikos, KritikosWeb.Endpoint,
  load_from_system_env: true,
  http: [:inet6, port: System.fetch_env!("PORT")],
  url: [host: "kritikos.app", port: 80],
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true,
  check_origin: false
  check_origin: ["//kritikos.app"]

# Do not print debug messages in production
config :logger, level: :info

config :phoenix, :serve_endpoints, true
