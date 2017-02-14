defmodule KlziiChat.Services.ConnectionLogService do
  alias KlziiChat.{Repo, Endpoint, ConnectionLog}

  def save(%{"params" => params, "method" => "collect"}) do
    ConnectionLog.changeset(%ConnectionLog{}, parse_params(params))
    |> Repo.insert()
    |> case  do
        {:ok, entry} ->
          Endpoint.broadcast!("logs:pull",
          "new_log_entry",
          KlziiChat.ConnectionLogView.render("show.json", %{connection_log: entry})
          )
          {:ok, entry}
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
      meta: get_in(params, ["meta"]),
      req: get_in(params, ["meta", "req"]),
      res: get_in(params, ["meta", "res"]),
      responseTime: get_in(params, ["meta", "responseTime"]),
    }
  end
end
