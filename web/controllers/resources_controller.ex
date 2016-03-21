defmodule KlziiChat.ResourcesController do
  use KlziiChat.Web, :controller
  alias KlziiChat.{Resource, Repo, ResourceView, AccountUser, GuardianSerializer}
  alias KlziiChat.Services.{ ResourceService }
  import Ecto
  import Ecto.Query


  def index(conn, params) do
    case getUser(params["jwt"]) do
      {:ok, result} ->
        query =  from(r in assoc(result.account_user.account, :resources))

        if params["type"] != "all"  do
          query = where(query, type: ^params["type"] )
        end

      resources =
        Repo.all(query)
        |> Enum.map(fn resource ->
          ResourceView.render("resource.json", %{resource: resource})
        end)

        json(conn, %{resources: resources})
      {:error, reason} ->
        json(conn, %{status: :error, reason: reason})
    end
  end

  def upload(conn, %{"type" => type, "scope" => scope, "file" => file, "jwt" => jwt, "name"=> name}) do
    case getUser(jwt) do
      {:ok, result} ->
        params = %{
          type: type,
          scope: scope,
          accountId: result.account_user.account.id,
          accountUserId: result.account_user.id,
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
      {:error, reason} ->
        json(conn, %{status: :error, reason: reason})
    end
  end

  @spec getUser(String.t) :: {:ok, %AccountUser{}} | {:error, String.t}
  defp getUser(token) do
    case Guardian.decode_and_verify(token) do
      {:ok, claims} ->
        case GuardianSerializer.from_token(claims["sub"]) do
          {:ok, result} ->
            {:ok, result}
          {:error, reason} ->
            {:error, reason}
        end
      {:error, reason} ->
        {:error, reason}
    end
  end
end
