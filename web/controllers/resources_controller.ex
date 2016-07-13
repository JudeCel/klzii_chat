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
    query =
      QueriesResources.base_query(member.account_user)
      |> QueriesResources.find_by_params(params)
    resources =
      Repo.all(query)
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

  def delete(conn, %{"ids" => ids}, member, _) do
    case ResourceService.deleteByIds(member.account_user.id, ids ) do
      {:ok, resources} ->
        resp = Enum.map(resources, fn resource ->
          ResourceView.render("delete.json", %{resource: resource})
        end)
        json(conn, %{ids: resp, message: "Success deleted!"})
      {:error, reason} ->
        put_status(conn, reason.code)
        |> json(error_view(reason))
    end
  end

  def show(conn, %{"id" => id}, member, _) do
    case ResourceService.find(member.account_user.id, id ) do
      {:ok, resource} ->
        json(conn, %{resource: ResourceView.render("resource.json", %{resource: resource}) })
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
