import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

config :sb_cascade,
  uploads_path: "priv/static/test_uploads"

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :sb_cascade, SbCascade.Repo,
  # database: Path.expand("../sb_cascade_test.db", __DIR__),
  # pool_size: 5,
  # pool: Ecto.Adapters.SQL.Sandbox
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "sb_cascade_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :sb_cascade, SbCascadeWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "JiYBy9hHUzO9qfdJead9rVM4ExY8pDi41mt/L8QmXQaeAsShI2m27w5HRZ/7kN+j",
  server: false

# In test we don't send emails
config :sb_cascade, SbCascade.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning
# config :logger, level: :debug

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true
