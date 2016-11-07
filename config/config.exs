# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :klzii_chat,
  ecto_repos: [KlziiChat.Repo]
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

config :guardian, Guardian,
  issuer: "KlziiChat",
  ttl: { 3, :days },
  verify_issuer: true,
  serializer: KlziiChat.Guardian.Serializer
# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

config :quantum, cron: [
    # Runs every midnight:
    "@daily":  &KlziiChat.Services.ResourceService.daily_cleanup/0
  ], timezone: :local

config :exq,
  name: Exq,
  namespace: "exq",
  concurrency: :infinite,
  queues: ["notify", {"report", 1}],
  poll_timeout: 50,
  scheduler_poll_timeout: 200,
  scheduler_enable: true,
  max_retries: 2,
  shutdown_timeout: 5000

config :exq_ui,
  web_namespace: "exq",
  server: true

import_config "#{Mix.env}.exs"
