defmodule KlziiChat.SessionResourcesController do
  use KlziiChat.Web, :controller
  alias KlziiChat.{SessionResourcesView, ResourceView}
  alias KlziiChat.Services.{ SessionResourcesService, ResourceService}
  alias KlziiChat.Queries.Resources, as: QueriesResources
  use Guardian.Phoenix.Controller

  plug Guardian.Plug.EnsureAuthenticated, handler: KlziiChat.Guardian.AuthErrorHandler
  plug :if_current_member

  def index(conn, params, member, _) do
    case SessionResourcesService.get_session_resources(member.session_member.id, params) do
      {:ok, session_resources} ->
        json(conn, Phoenix.View.render_many(session_resources, SessionResourcesView, "show.json", as: :session_resource))
      {:error, reason} ->
        json(conn, %{status: :error, reason: reason})
    end
  end

  def create(conn, %{"ids" => ids}, member, _) do
    case SessionResourcesService.add_session_resources(ids, member.session_member.id) do
      {:ok, _} ->
        json(conn, %{status: :ok})
      {:error, reason} ->
        json(conn, %{error:  reason})
    end
  end

  # def show(conn, %{"id" => id}, member, _) do
  #   case SessionResourcesService.find(member.session_member.id, id) do
  #     {:ok, session_resource} ->
  #       json(conn, Phoenix.View.render(session_resource, SessionResourcesView, "show.json", as: :session_resource))
  #     {:error, reason} ->
  #       json(conn, %{error:  reason})
  #   end
  # end

  def upload(conn, params, member, _) do
    case ResourceService.upload(params, member.account_user.id) do
      {:ok, resource} ->
        SessionResourcesService.add_session_resources(resource.id, member.session_member.id)
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

  def gallery(conn, params, member, _) do
    resources =
      QueriesResources.base_query(member.account_user)
      |> QueriesResources.find_by_params(params)
      |> QueriesResources.exclude_by_session_id(member.account_user.account.id, member.session_member.id)
      |> Repo.all
      |> Phoenix.View.render_many(ResourceView, "resource.json", as: :resource)
    json(conn, resources)
  end

  defp if_current_member(conn, opts) do
    if Guardian.Plug.current_resource(conn) do
      conn
    else
      KlziiChat.Guardian.AuthErrorHandler.unauthenticated(conn, opts)
    end
 end
end
