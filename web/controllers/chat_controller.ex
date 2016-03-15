defmodule KlziiChat.ChatController do
  use KlziiChat.Web, :controller
  alias KlziiChat.{Resource, Repo}

  def index(conn, %{"token" => token}) do
    render conn, "index.html" , token: token
  end

  def upload(conn, %{"type" => type, "scope" => scope, "file" => file, "topicId" => topic_id, "memberId"=> sessionMemberId}) do
    resource = %{topic_id: topic_id, type: type, scope: scope, type: type, sessionMemberId: sessionMemberId }
      |> Map.put(String.to_atom(type), file)
    changeset = Resource.changeset(%Resource{}, resource)

    case Repo.insert(changeset) do
      {:ok, resource} ->
        json(conn, %{status: :ok})
      {:error, reason} ->
        json(conn, %{status: :error, reason: "reason"})
    end
  end
end
