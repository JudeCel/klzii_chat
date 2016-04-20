defmodule KlziiChat.ResourcesController do
  use KlziiChat.Web, :controller
  alias KlziiChat.{Resource, Repo, ResourceView, AccountUser}
  alias KlziiChat.Services.{ ResourceService }
  import Ecto
  import Ecto.Query
  use Guardian.Phoenix.Controller

  plug Guardian.Plug.EnsureAuthenticated, handler: KlziiChat.Guardian.AuthErrorHandler
  plug :if_current_user

  def ping(conn, _, user, claims) do
    json(conn, %{status: :ok})
  end

  def index(conn, params, user, claims) do
    query =  from(r in assoc(user.account, :resources))

    if params["type"] != "all"  do
      query = where(query, type: ^params["type"] )
    end

    resources =
      Repo.all(query)
      |> Enum.map(fn resource ->
        ResourceView.render("resource.json", %{resource: resource})
      end)
    json(conn, %{resources: resources})
  end

  def zip(conn, %{"ids" => ids, "name" => name}, user, claims) do
    case ResourceService.create_new_zip(user, name, ids ) do
      {:ok, resource} ->
        json(conn, %{resource: ResourceView.render("resource.json", %{resource: resource}) })
      {:error, reason} ->
        json(conn, %{status: :error, reason: reason})
    end
  end

  def delete(conn, %{"ids" => ids}, user, claims) do
    case ResourceService.deleteByIds(user.id, ids ) do
      {:ok, resources} ->
        resp = Enum.map(resources, fn resource ->
          ResourceView.render("delete.json", %{resource: resource})
        end)
        json(conn, %{ids: resp })
      {:error, reason} ->
        json(conn, %{status: :error, reason: reason})
    end
  end

  def show(conn, %{"id" => id}, user, claims) do
    case ResourceService.find(user.id, id ) do
      {:ok, resource} ->
        json(conn, %{resource: ResourceView.render("resource.json", %{resource: resource}) })
      {:error, reason} ->
        json(conn, %{status: :error, reason: reason})
    end
  end

  def upload(conn, %{"type" => type, "scope" => scope, "file" => file, "name"=> name}, user, claims) do
    params = %{
      type: type,
      scope: scope,
      accountId: user.account.id,
      accountUserId: user.id,
      type: type,
      name: name
    } |> Map.put(String.to_atom(type), file)
    changeset = Resource.changeset(%Resource{}, params)

    case Repo.insert(changeset) do
      {:ok, resource} ->
        json(conn, %{type: resource.type, resources: [ ResourceView.render("resource.json", %{resource: resource}) ] })
      {:error, reason} ->
        json(conn, %{status: :error, reason: reason})
    end
  end

  defp if_current_user(conn, opts) do
    if Guardian.Plug.current_resource(conn) do
      conn
    else
      KlziiChat.Guardian.AuthErrorHandler.unauthenticated(conn, opts)
    end
 end
end
