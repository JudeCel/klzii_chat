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
     {:phoenix_pubsub, "~> 1.0.0-rc.0"},
     {:phoenix_ecto, "~> 3.0"},
     {:phoenix_html, "~> 2.6"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:timex_ecto, "~> 1.1"},
     {:poison, "~> 2.1", override: true},
     {:arc_ecto, "~> 0.4.1"},
     {:arc, "~> 0.5.2"},
     {:ex_aws, "~> 0.4.19"},
     {:httpotion, "~> 3.0", override: true},
     {:postgrex, "~> 0.11.2"},
     {:gettext, "~> 0.11.0"},
     {:guardian, "~> 0.12.0"},
     {:cowboy, "~> 1.0"},
     {:corsica, "~> 0.4.2"},
     {:timex, "~> 2.1"},
     {:quantum, "~> 1.7"},
     {:httpoison, "~> 0.8.3"},
     {:earmark, "~> 0.2.1", only: :dev},
     {:ex_doc, "~> 0.12.0", only: :dev},
     {:credo, "~> 0.4.3", only: :dev}
    ]
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
