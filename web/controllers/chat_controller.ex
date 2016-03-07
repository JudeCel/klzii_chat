defmodule KlziiChat.ChatController do
  use KlziiChat.Web, :controller
  alias KlziiChat.{Resource, Repo}

  def index(conn, %{"token" => token}) do
    render conn, "index.html" , token: token
  end

  def upload(conn, %{"file" => file, "userId" => userId, "topicId" => topicId }) do
    resource = %{URL: file, resourceType: "image", userId: userId, topicId: topicId}
    changeset = Resource.changeset(%Resource{},  resource)
    case Repo.insert(changeset) do
      {:ok, _resource} ->
        json(conn, %{status: :ok})
      {:error, reason} ->
        json(conn, %{status: :error, reason: reason})
    end
  end
end
