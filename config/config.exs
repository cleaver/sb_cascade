# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :sb_cascade,
  ecto_repos: [SbCascade.Repo],
  generators: [timestamp_type: :utc_datetime],
  local_timezone: "America/New_York",
  admin_default_page_size: 10,
  api_default_page_size: 10,
  uploads_path: "uploads"

# Configures the endpoint
config :sb_cascade, SbCascadeWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: SbCascadeWeb.ErrorHTML, json: SbCascadeWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: SbCascade.PubSub,
  live_view: [signing_salt: "BXjR/sCY"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :sb_cascade, SbCascade.Mailer, adapter: Swoosh.Adapters.Local

# Flop config
config :flop, repo: SbCascade.Repo

config :flop_phoenix,
  pagination: [opts: {SbCascadeWeb.Components.FlopComponents, :pagination_opts}],
  table: [opts: {SbCascadeWeb.Components.FlopComponents, :table_opts}]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  sb_cascade: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  sb_cascade: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Time zone database
config :elixir, :time_zone_database, Tz.TimeZoneDatabase

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
