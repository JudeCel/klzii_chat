defmodule KlziiChat.SessionResourcesController do
  use KlziiChat.Web, :controller
  alias KlziiChat.{SessionResourcesView}
  alias KlziiChat.Services.{ SessionResourcesService, ResourceService}
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

  def create(conn, %{"resource_ids" => resource_ids}, member, _) do
    case SessionResourcesService.add_session_resources(member.session_member.sessionId, resource_ids, member.session_member.id) do
      {:ok, _} ->
        json(conn, %{status: :ok})
      {:error, reason} ->
        json(conn, %{error:  reason})
    end
  end

  def upload(conn, params, member, _) do
    case ResourceService.upload(params, member.account_user.id) do
      {:ok, resource} ->
        SessionResourcesService.add_session_resources([resource.id], member.session_member.id)
        json(conn, %{status: :ok})
      {:error, reason} ->
        json(conn, %{status: :error, reason: reason})
    end
  end

  def delete(conn, %{"id" => id}, member, _) do
    case SessionResourcesService.delete(member.session_member.id, id) do
      {:ok, _} ->
        json(conn, %{status: :ok})
      {:error, reason} ->
        json(conn, %{status: :error, reason: reason})
    end
  end

  defp if_current_member(conn, opts) do
    if Guardian.Plug.current_resource(conn) do
      conn
    else
      KlziiChat.Guardian.AuthErrorHandler.unauthenticated(conn, opts)
    end
 end
end
