defmodule KlziiChat.ResourcesController do
  use KlziiChat.Web, :controller
  import KlziiChat.ErrorHelpers, only: [error_view: 1]
  alias KlziiChat.{Repo, ResourceView}
  alias KlziiChat.Services.{ ResourceService }
  alias KlziiChat.Queries.Resources, as: QueriesResources
  use Guardian.Phoenix.Controller

  plug Guardian.Plug.EnsureAuthenticated, handler: KlziiChat.Guardian.AuthErrorHandler
  plug :if_current_member

  def ping(conn, _, _, _) do
    json(conn, %{status: :ok})
  end

  def index(conn, params, member, _) do
    resources =
      QueriesResources.base_query(member.account_user)
      |> QueriesResources.find_by_params(params)
      |> QueriesResources.stock_query(%{"stock" => false})
      |> Repo.all
    stock_resources =
      QueriesResources.base_query
        |> QueriesResources.stock_query(params)
        |> QueriesResources.find_by_params(params)
        |> Repo.all

      list = Enum.map((stock_resources ++ resources), fn resource ->
        ResourceView.render("resource.json", %{resource: resource})
      end)
    json(conn, %{resources: list})
  end

  def stock(conn, params) do
    resources =
      QueriesResources.base_query()
      |> QueriesResources.find_by_params(params)
      |> QueriesResources.stock_query(true)
      |> Repo.all
      |> Enum.map(fn resource ->
        ResourceView.render("resource.json", %{resource: resource})
      end)
    json(conn, %{resources: resources})
  end

  def zip(conn, %{"ids" => ids, "name" => name}, member, _) do
    case ResourceService.create_new_zip(member.account_user.id, name, ids ) do
      {:ok, resource} ->
        json(conn, %{resource: ResourceView.render("resource.json", %{resource: resource}) })
      {:error, reason} ->
        put_status(conn, reason.code)
        |> json(error_view(reason))
    end
  end

  def closed_session_delete_check(conn, %{"ids" => ids}, member, _) do
    case ResourceService.closed_session_delete_check_by_ids(member.account_user.id, ids) do
      {:ok, items} ->
        items_resp = ResourceView.render("delete_items.json", %{data: items, message: "Selected files: {0} are used in Closed Session. Do you still want to Delete them?"})
        json(conn, items_resp)
      {:error, reason} ->
        put_status(conn, reason.code)
        |> json(error_view(reason))
    end
  end

  def delete(conn, %{"ids" => ids}, member, _) do
    case ResourceService.deleteByIds(member.account_user.id, ids) do
      {:ok, removed, not_removed_stock, not_removed_used} ->
        removed_resp = ResourceView.render("delete_items.json", %{data: removed, message: "Your selected files were successfully deleted"})
        not_removed_stock_resp = ResourceView.render("delete_items.json", %{data: not_removed_stock, message: "Sorry, we cannot Delete the following because they are Stock file: {0}"})
        not_removed_used_resp = ResourceView.render("delete_items.json", %{data: not_removed_used, message: "Sorry, we cannot delete the following files as they are currently used in a Chat Session: {0}"})
        json(conn, %{removed: removed_resp, not_removed_stock: not_removed_stock_resp, not_removed_used: not_removed_used_resp })
      {:error, reason} ->
        put_status(conn, reason.code)
        |> json(error_view(reason))
    end
  end

  def show(conn, %{"id" => id}, member, _) do
    case ResourceService.find(member.account_user.id, id ) do
      {:ok, resource} ->
        json(conn, %{ resource: ResourceView.render("resource.json", %{resource: resource}) })
      {:error, reason} ->
        put_status(conn, reason.code)
        |> json(error_view(reason))
    end
  end

  def upload(conn, params, member, _) do
    case ResourceService.upload(params, member.account_user.id) do
      {:ok, resource} ->
        json(conn, %{
        type: resource.type,
        resource: ResourceView.render("resource.json", %{resource: resource}),
        message: "File successfully uploaded" })
      {:error, reason} ->
        put_status(conn, reason.code)
        |> json(error_view(reason))
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
