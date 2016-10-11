defmodule KlziiChat.DbCleanHelper do
  def clean_up do
    host = Application.get_env(:exq, :host)
    database = Application.get_env(:exq, :database)
    {:ok, conn} = Redix.start_link(database: database, host: host)
    {:ok, _} = Redix.command(conn, ~W(FLUSHDB))
  end
end
