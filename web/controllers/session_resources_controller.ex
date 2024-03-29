defmodule KlziiChat.SessionResourcesController do
  use KlziiChat.Web, :controller
  import KlziiChat.ErrorHelpers, only: [error_view: 1]
  alias KlziiChat.{SessionResourcesView, ResourceView}
  alias KlziiChat.Services.{ SessionResourcesService, ResourceService}
  alias KlziiChat.Queries.Resources, as: QueriesResources
  alias KlziiChat.Helpers.{PagesHelper}
  use Guardian.Phoenix.Controller

  plug Guardian.Plug.EnsureAuthenticated, handler: KlziiChat.Guardian.AuthErrorHandler
  plug :if_current_member

  @galery_items_on_page 9
  @default_page 1

  def index(conn, params, member, _) do
    case SessionResourcesService.get_session_resources(member.session_member.id, params) do
      {:ok, session_resources} ->
        json(conn, Phoenix.View.render_many(session_resources, SessionResourcesView, "show.json", as: :session_resource))
      {:error, reason} ->
        conn
        |> put_status(400)
        |> json(error_view(reason))
    end
  end

  def create(conn, %{"ids" => ids}, member, _) do
    case SessionResourcesService.add_session_resources(ids, member.session_member.id) do
      {:ok, _} ->
        json(conn, %{status: :ok})
      {:error, reason} ->
        conn
        |> put_status(400)
        |> json(error_view(reason))
    end
  end

  def upload(conn, params, member, _) do
    case ResourceService.upload(params, member.account_user.id) do
      {:ok, resource} ->
        SessionResourcesService.add_session_resources(resource.id, member.session_member.id)
        json(conn, %{status: :ok})
      {:error, reason} ->
        conn
        |> put_status(reason.code)
        |> json(error_view(reason))
    end
  end

  def delete(conn, %{"id" => id}, member, _) do
    case SessionResourcesService.delete(member.session_member.id, id) do
      {:ok, session_resource} ->
        json(conn, KlziiChat.SessionResourcesView.render("delete.json", %{session_resource: session_resource}))
      {:error, reason} ->
        conn
        |> put_status(reason.code)
        |> json(error_view(reason))
    end
  end

  def gallery(conn, params, member, _) do
    {:ok, session_resources} = SessionResourcesService.get_session_resources(member.session_member.id, params)
    account_resources_task =
      Task.async(fn ->
        QueriesResources.base_query(member.account_user)
        |> QueriesResources.find_by_params(params)
        |> QueriesResources.stock_query(%{"stock" => false})
        |> QueriesResources.exclude_by_ids(session_resources)
        |> Repo.all
      end)
      
    stock_resources_task =
      Task.async(fn ->
        QueriesResources.base_query
          |> QueriesResources.find_by_params(params)
          |> QueriesResources.stock_query(%{"stock" => true})
          |> QueriesResources.exclude_by_ids(session_resources)
          |> Repo.all
      end)

    all_resources = (Task.await(stock_resources_task) ++ Task.await(account_resources_task))
    page = case Integer.parse(params["page"] || "1") do
      :error ->
        @default_page
      {integer, _} ->
        integer
    end
    {data, pages} = PagesHelper.paginate(all_resources, page, @galery_items_on_page)

    json(conn, Phoenix.View.render_one(%{resources: data, pages: pages}, ResourceView, "resources.json", as: :data))
  end

  defp if_current_member(conn, opts) do
    if Guardian.Plug.current_resource(conn) do
      conn
    else
      KlziiChat.Guardian.AuthErrorHandler.unauthenticated(conn, opts)
    end
 end
end
