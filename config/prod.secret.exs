use Mix.Config
# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :klzii_chat, KlziiChat.Endpoint,
  secret_key_base: System.get_env("SECRET_KEY_BASE")

# Configure your database
config :klzii_chat, KlziiChat.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DB_USERNAME"),
  database: System.get_env("DB_DATABASE"),
  hostname: System.get_env("DB_HOST"),
  password: System.get_env("DB_PASSWORD"),
  prepare: :unnamed,
  pool_size: 6

config :ex_aws,
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
  region: System.get_env("AWS_REGION"),
  debug_requests: true

config :arc,
  storage: Arc.Storage.S3,
  bucket: System.get_env("ARC_BUCKET"),
  virtual_host: true

config :guardian, Guardian,
  secret_key: System.get_env("GUARDIAN_SECRET_KEY")

config :klzii_chat, KlziiChat.DatabaseMonitoring.Listener,
  username: System.get_env("DB_USERNAME"),
  database: System.get_env("DB_DATABASE"),
  hostname: System.get_env("DB_HOST"),
  password: System.get_env("DB_PASSWORD")

config :exq,
  host: System.get_env("REDIS_HOST")

config :klzii_chat,
  resources_conf: %{
  dashboard_url: System.get_env("DASHBOARD_URL")
}
