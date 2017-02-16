defmodule KlziiChat.ConnectionLogView do
  use KlziiChat.Web, :view

  @spec render(String.t, Map.t) :: Map.t
  def render("index.json", %{connection_log: connection_log}) do
    %{
      id: connection_log.id,
      userId: connection_log.userId,
      accountId: connection_log.accountId,
      accountUserId: connection_log.accountUserId,
      responseTime: connection_log.responseTime,
      application: connection_log.application,
      level: connection_log.level,
      path: get_in(connection_log.req, ["url"]),
      response_status_code: get_in(connection_log.res, ["statusCode"]),
      accountUserRole: get_in(connection_log.meta, ["currentResources", "accountUser", "role"]),
      details_url: logs_path(KlziiChat.Endpoint, :show, connection_log.id)
    }
  end
  @spec render(String.t, Map.t) :: Map.t
  def render("show.json", %{connection_log: connection_log}) do
    %{
      id: connection_log.id,
      userId: connection_log.userId,
      accountId: connection_log.accountId,
      accountUserId: connection_log.accountUserId,
      application: connection_log.application,
      responseTime: connection_log.responseTime,
      level: connection_log.level,
      req: connection_log.req,
      res: connection_log.res,
      meta: connection_log.meta
    }
  end
end
