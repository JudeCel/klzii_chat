# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :klzii_chat, KlziiChat.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "64dHOpQEe+vNCIA3GwVYoFf2PguXQcLcIyETM23XasBSHFnks64zTu8zsySDxJqI",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: KlziiChat.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :guardian, Guardian,
  issuer: "KlziiChat",
  ttl: { 3, :days },
  verify_issuer: true,
  serializer: KlziiChat.Guardian.Serializer,
  secret_key: "B08B27270CA410609F006AD7A25C50142850256103F55ECF3BFBF0279186108C"
# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false
