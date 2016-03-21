defmodule KlziiChat.ResourcesController do
  use KlziiChat.Web, :controller
  alias KlziiChat.{Resource, Repo, ResourceView, AccountUser, GuardianSerializer}
  alias KlziiChat.Services.{ ResourceService }

  def index(conn, %{"jwt" => jwt, "type" => type}) do
    case getUser(jwt) do
      {:ok, result} ->
        resources = Repo.all(
          from e in assoc(result.account_user.account, :resources)
        )
        resp = Enum.map(resources, fn resource ->
          ResourceView.render("resource.json", %{resource: resource})
        end)

        json(conn, %{status: :error, reason: resp})
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
