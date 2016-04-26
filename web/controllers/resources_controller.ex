defmodule KlziiChat.ResourcesController do
  use KlziiChat.Web, :controller
  alias KlziiChat.{Resource, Repo, ResourceView, AccountUser}
  alias KlziiChat.Services.{ ResourceService }
  alias KlziiChat.Queries.Resources, as: QueriesResources
  use Guardian.Phoenix.Controller

  plug Guardian.Plug.EnsureAuthenticated, handler: KlziiChat.Guardian.AuthErrorHandler
  plug :if_current_account_user

  def ping(conn, _, account_user, claims) do
    json(conn, %{status: :ok})
  end

  def index(conn, params, account_user, claims) do
    query =
      QueriesResources.add_role_scope(account_user)
      |> QueriesResources.find_by_params(params)
    resources =
      Repo.all(query)
      |> Enum.map(fn resource ->
        ResourceView.render("resource.json", %{resource: resource})
      end)
    json(conn, %{resources: resources})
  end

  def zip(conn, %{"ids" => ids, "name" => name}, account_user, claims) do
    case ResourceService.create_new_zip(account_user.id, name, ids ) do
      {:ok, resource} ->
        json(conn, %{resource: ResourceView.render("resource.json", %{resource: resource}) })
      {:error, reason} ->
        json(conn, %{status: :error, reason: reason})
    end
  end

  def delete(conn, %{"ids" => ids}, account_user, claims) do
    case ResourceService.deleteByIds(account_user.id, ids ) do
      {:ok, resources} ->
        resp = Enum.map(resources, fn resource ->
          ResourceView.render("delete.json", %{resource: resource})
        end)
        json(conn, %{ids: resp, message: "Success deleteed!"})
      {:error, reason} ->
        json(conn, %{status: :error, reason: reason})
    end
  end

  def show(conn, %{"id" => id}, account_user, claims) do
    case ResourceService.find(account_user.id, id ) do
      {:ok, resource} ->
        json(conn, %{resource: ResourceView.render("resource.json", %{resource: resource}) })
      {:error, reason} ->
        json(conn, %{status: :error, reason: reason})
    end
  end

  def upload(conn, %{"type" => type, "scope" => scope, "file" => file, "name"=> name}, account_user, claims) do
    params = %{
      type: type,
      scope: scope,
      accountId: account_user.account.id,
      accountUserId: account_user.id,
      type: type,
      name: name
    } |> Map.put(String.to_atom(type), file)
    changeset = Resource.changeset(%Resource{}, params)

    case Repo.insert(changeset) do
      {:ok, resource} ->
        json(conn, %{
          type: resource.type,
          resource: ResourceView.render("resource.json", %{resource: resource}),
          message: "Success uploaded!" })
      {:error, reason} ->
        json(conn, %{status: :error, reason: reason})
    end
  end

  defp if_current_account_user(conn, opts) do
    if Guardian.Plug.current_resource(conn) do
      conn
    else
      KlziiChat.Guardian.AuthErrorHandler.unauthenticated(conn, opts)
    end
 end
end
