defmodule KlziiChat.SessionResourcesController do
  use KlziiChat.Web, :controller
  alias KlziiChat.{SessionResourcesView}
  alias KlziiChat.Services.{ SessionResourcesService }
  use Guardian.Phoenix.Controller

  plug Guardian.Plug.EnsureAuthenticated, handler: KlziiChat.Guardian.AuthErrorHandler
  plug :if_current_member

  def index(conn, _, member, _) do
    case SessionResourcesService.get_session_resources(member.session_member.sessionId, member.session_member.id) do
      {:ok, session_resources} ->
        json(conn, Phoenix.View.render_many(session_resources, SessionResourcesView, "show.json", as: :session_resource))
      {:error, reason} ->
        json(conn, %{status: :error, reason: reason})
    end
  end

  def toggle(conn, %{"resourceIds" => resource_ids}, member, _) do
    :ok = SessionResourcesService.toggle(member.session_member.sessionId, resource_ids, member.session_member.id)
    json(conn, %{status: :ok})
  end

  defp if_current_member(conn, opts) do
    if Guardian.Plug.current_resource(conn) do
      conn
    else
      KlziiChat.Guardian.AuthErrorHandler.unauthenticated(conn, opts)
    end
 end
end
