defmodule KlziiChat.ChatController do
  use KlziiChat.Web, :controller
  alias KlziiChat.{Resource, Repo, ResourceView, AccountUser, GuardianSerializer}

  def index(conn, %{"token" => token}) do
    render conn, "index.html" , token: token
  end

  def upload(conn, %{"type" => type, "scope" => scope, "file" => file, "jwt" => jwt, "name"=> name}) do
    case getUser(jwt) do
      {:ok, result} ->
        resource = %{
          type: type,
          scope: scope,
          accountId: result.account_user.account.id,
          accountUserId: result.account_user.id,
          type: type,
          name: name
        }
        |> Map.put(String.to_atom(type), file)
        changeset = Resource.changeset(%Resource{}, resource)

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
