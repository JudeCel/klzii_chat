use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :klzii_chat, KlziiChat.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
# config :logger, :console, format: "[$level] $message\n"

# Configure your database
config :klzii_chat, KlziiChat.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "dNtVsN78",
  database: "kliiko_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  sql_sandbox: true

config :guardian, Guardian,
    secret_key: "SttPra/cddsnX+Vko2i8KA=="

config :klzii_chat, KlziiChat.DatabaseMonitoring.Listener,
  database: "kliiko_test",
  username: "postgres",
  password: "dNtVsN78",
  hostname: "localhost"

config :exq,
  host: "127.0.0.1",
  database: 4
