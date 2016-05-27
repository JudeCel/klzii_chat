defmodule KlziiChat.Mixfile do
  use Mix.Project

  def project do
    [app: :klzii_chat,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {KlziiChat, []},
     applications: [:phoenix, :phoenix_html, :cowboy, :logger, :gettext, :quantum, :phoenix_pubsub,
                    :phoenix_ecto, :postgrex, :ex_aws, :arc, :httpotion, :timex_ecto, :httpoison]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.2.0-rc.1"},
     {:phoenix_pubsub, "~> 1.0.0-rc"},
     {:phoenix_ecto, github: "phoenixframework/phoenix_ecto"},
     {:phoenix_html, "~> 2.5"},
     {:phoenix_live_reload, "~> 1.0.5", only: :dev},
     {:timex_ecto, github: "bitwalker/timex_ecto"},
     {:poison, "~> 2.1", override: true},
     {:arc_ecto, "~> 0.4.1"},
     {:arc, "~> 0.5.2"},
     {:ex_aws, "~> 0.4.18"},
     {:httpotion, "~> 2.2.2"},
     {:postgrex,  "~> 0.11.1"},
     {:gettext, "~> 0.11"},
     {:guardian, "~> 0.10.1"},
     {:cowboy, "~> 1.0.4"},
     {:corsica, "~> 0.4"},
     {:timex, "~> 2.1"},
     {:quantum, "~> 1.7"},
     {:httpoison, "~> 0.8"},
     {:earmark, "~> 0.1", only: :dev},
     {:ex_doc, "~> 0.11", only: :dev},
     {:credo, "~> 0.4.0-beta1", only: :dev}]
  end

  # Aliases are shortcut or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
