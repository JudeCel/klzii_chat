defmodule KlziiChat.ChatController do
  use KlziiChat.Web, :controller
  alias KlziiChat.{Resource, Repo}

  def index(conn, %{"token" => token}) do
    render conn, "index.html" , token: token
  end

  def upload(conn, %{"type" => type, "scope" => scope, "file" => file, "topicId" => topic_id, "userId"=> user_id}) do
    resource = %{image:  file, type: type, scope: scope, type: type, userId: user_id }
    changeset = Resource.changeset(%Resource{}, resource)

    case Repo.insert(changeset) do
      {:ok, resource} ->
        # IO.inspect resource
        json(conn, %{status: :ok})
      {:error, reason} ->
        IO.inspect reason
        json(conn, %{status: :error, reason: "reason"})
    end
  end
end
