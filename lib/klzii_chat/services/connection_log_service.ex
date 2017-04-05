defmodule KlziiChat.Services.ConnectionLogService do
  alias KlziiChat.{Repo, Endpoint, ConnectionLog, ConnectionLogView}
  alias KlziiChat.Queries.ConnectionLogs, as: ConnectionLogsQueries
  import Ecto.Query, only: [from: 2]

  def history(filters) do
    result =
      ConnectionLogsQueries.base()
      |> ConnectionLogsQueries.filter(filters)
      |> Repo.all
      |> Phoenix.View.render_many(ConnectionLogView, "index.json", as: :connection_log)
      {:ok, result}
  end

  def save(%{"params" => params, "method" => "collect"}) do
    ConnectionLog.changeset(%ConnectionLog{}, parse_params(params))
    |> Repo.insert()
    |> case  do
        {:ok, connection_log} ->
          Endpoint.broadcast!("logs:pull",
          "new_log_entry",
          ConnectionLogView.render("index.json", %{connection_log: connection_log})
          )
          {:ok, connection_log}
        {:error, reason} ->
          {:error, reason}
      end
  end

  def parse_params(params) do
    %{
      level: get_in(params, ["level"]),
      userId:  get_in(params, ["meta", "currentResources", "user", "id"]),
      accountUserId: get_in(params, ["meta", "currentResources", "accountUser", "id"]),
      accountId:  get_in(params, ["meta", "currentResources", "account", "id"]),
      application:  get_in(params, ["meta", "application"]),
      meta: get_in(params, ["meta"]),
      req: get_in(params, ["meta", "req"]),
      res: get_in(params, ["meta", "res"]),
      responseTime: get_in(params, ["meta", "responseTime"]),
    }
  end

  def get(id) do
    Repo.get(ConnectionLog, id)
    |> case  do
        nil ->
          {:error, "not found"}
        connection_log ->
          {:ok, ConnectionLogView.render("show.json", %{connection_log: connection_log})}
      end
  end

  @spec daily_cleanup() :: {:ok, list}
  def daily_cleanup() do
    date  = Timex.now("UTC") |> Timex.shift(months: -2)
    from(e in ConnectionLog,
      where: e.createdAt < ^date,
    )
    |> Repo.delete_all
  end
end
