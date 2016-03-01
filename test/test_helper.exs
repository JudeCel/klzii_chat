ExUnit.start

Mix.Task.run "ecto.create", ~w(-r KlziiChat.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r KlziiChat.Repo --quiet)
# Ecto.Adapters.SQL.Sandbox.mode(KlziiChat.Repo, {:shared, self()})
# Ecto.Adapters.SQL.Sandbox.mode(KlziiChat.Repo, :manual)
Ecto.Adapters.SQL.begin_test_transaction(KlziiChat.Repo)
