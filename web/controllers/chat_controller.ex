defmodule KlziiChat.ChatController do
  use KlziiChat.Web, :controller
  alias KlziiChat.{Resource, Repo}

  def index(conn, %{"token" => token}) do
    render conn, "index.html" , token: token
  end

  def upload(conn, %{"resourceType" => resourceType, "file" => file, "topic_id" => topic_id, "user_id"=> user_id}) do
    resource = %{URL: file, resourceType: resourceType, topicId: topic_id, userId: user_id }
    changeset = Resource.changeset(%Resource{},  resource)
    case Repo.insert(changeset) do
      {:ok, _resource} ->
        json(conn, %{status: :ok})
      {:error, reason} ->
        json(conn, %{status: :error, reason: reason})
    end
  end
end
