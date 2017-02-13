defmodule KlziiChat.Services.ConnectionLogService do
  alias KlziiChat.{Repo, ConnectionLog}
  import Ecto.Query

  def save(%{"params" => params, "method" => "collect"}) do
    ConnectionLog.changeset(%ConnectionLog{}, parse_params(params))
    |> Repo.insert()
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
