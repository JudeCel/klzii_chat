defmodule KlziiChat.JWTAuthErrorHandler do
  import Plug.Conn

  def unauthenticated(conn, opts) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, Poison.encode!(%{error: "unauthorized"}))
  end
end

defmodule KlziiChat.ResourcesController do
  use KlziiChat.Web, :controller
  alias KlziiChat.{Resource, Repo, ResourceView, AccountUser, GuardianSerializer}
  alias KlziiChat.Services.{ ResourceService }
  import Ecto
  import Ecto.Query
  use Guardian.Phoenix.Controller

  plug Guardian.Plug.EnsureAuthenticated, handler: KlziiChat.JWTAuthErrorHandler

  def ping(conn, _, user, claims) do
    json(conn, %{status: :ok})
  end


  def index(conn, params, user, claims) do
    query =  from(r in assoc(user.account_user.account, :resources))

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

  def upload(conn, %{"type" => type, "scope" => scope, "file" => file, "name"=> name}, user, claims) do
    params = %{
      type: type,
      scope: scope,
      accountId: user.account_user.account.id,
      accountUserId: user.account_user.id,
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
end
