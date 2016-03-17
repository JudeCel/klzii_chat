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
  database: System.get_env("DB_HOST"),
  password: System.get_env("DB_PASSWORD"),
  pool_size: 10
