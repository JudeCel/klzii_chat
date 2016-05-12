defmodule KlziiChat.SessionResourcesController do
  use KlziiChat.Web, :controller
  alias KlziiChat.{SessionResourcesView}
  alias KlziiChat.Services.{ SessionResourceService }
  use Guardian.Phoenix.Controller

  plug Guardian.Plug.EnsureAuthenticated, handler: KlziiChat.Guardian.AuthErrorHandler
  plug :if_current_account_user

  def ping(conn, _, _, _) do
    json(conn, %{status: :ok})
  end

  def get(conn, %{"session_id" => session_id}, session_member, _) do
    case SessionResourceService.get_session_resources(session_id, session_member.id) do
      {:ok, session_resources_ids} ->
        json(conn, %{session_resources_ids: SessionResourcesView.render("session_resources.json", %{session_resources_ids: session_resources_ids}) })
      {:error, reason} ->
        json(conn, %{status: :error, reason: reason})
    end
  end

  def toggle(conn, %{"session_id" => session_id}, session_member, _) do
  end

  defp if_current_account_user(conn, opts) do
    if Guardian.Plug.current_resource(conn) do
      conn
    else
      KlziiChat.Guardian.AuthErrorHandler.unauthenticated(conn, opts)
    end
 end
end
