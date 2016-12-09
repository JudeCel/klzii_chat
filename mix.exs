defmodule KlziiChat.Mixfile do
  use Mix.Project

  def project do
    [app: :klzii_chat,
     version: "0.0.1",
     elixir: "~> 1.3",
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
                    :phoenix_ecto, :postgrex, :ex_aws, :arc, :httpotion, :timex_ecto, :httpoison, :exq]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.2"},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix_ecto, "~> 3.0"},
     {:phoenix_html, "~> 2.8"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:timex_ecto, "~> 3.0"},
     {:csv, "~> 1.4"},
     {:boltun, "~> 1.0"},
     {:exq, "~> 0.8"},
     {:exq_ui, "~> 0.8"},
     {:plug_basic_auth, "~> 1.1"},
     {:timex, "~> 3.0"},
     {:quantum, "~> 1.7"},
     {:poison, "~> 2.2"},
     {:arc_ecto, "~> 0.4"},
     {:arc, "~> 0.5.3"},
     {:ex_aws, "~> 0.5"},
     {:httpotion, "~> 3.0"},
     {:postgrex, "~> 0.12"},
     {:gettext, "0.11.0"},
     {:guardian, "~> 0.12"},
     {:cowboy, "~> 1.0"},
     {:corsica, "~> 0.5"},
     {:httpoison, "~> 0.9"},
     {:mogrify, "~> 0.4.0"},
     {:earmark, "~> 1.0", only: :dev},
     {:ex_doc, "~> 0.13", only: :dev},
     {:credo, "~> 0.4", only: :dev}
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
