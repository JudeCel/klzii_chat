defmodule KlziiChat.ChatController do
  use KlziiChat.Web, :controller
  alias KlziiChat.{Resource, Repo, ResourceView}

  def index(conn, %{"token" => token}) do
    render conn, "index.html" , token: token
  end

  def upload(conn, %{"type" => type, "scope" => scope, "file" => file, "topicId" => topicId, "memberId"=> sessionMemberId, "name"=> name}) do
    resource = %{topicId: topicId, type: type, scope: scope, type: type, sessionMemberId: sessionMemberId, name: name, accountId: 1 }
      |> Map.put(String.to_atom(type), file)
    changeset = Resource.changeset(%Resource{}, resource)

    case Repo.insert(changeset) do
      {:ok, resource} ->
        json(conn, %{type: resource.type, resources: [ ResourceView.render("resource.json", %{resource: resource}) ] })
      {:error, reason} ->
        json(conn, %{status: :error, reason: "reason"})
    end
  end
end
