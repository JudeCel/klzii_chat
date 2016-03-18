use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :klzii_chat, KlziiChat.Endpoint,
  secret_key_base: "276977DDB3E2D46257CFF10D113A704A65B490F1855619637C0A0423F9C8D884"

# Configure your database
config :klzii_chat, KlziiChat.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  database: "kliiko_development",
  hostname: "localhost",
  pool_size: 10

config :ex_aws,
  access_key_id: "AKIAJV2UHLF355DYBP6A",
  secret_access_key: "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",
  region: "eu-west-1"
config :arc,
  bucket: "klzii-development"

config :guardian, Guardian,
  secret_key: "SttPra/cddsnX+Vko2i8KA=="
