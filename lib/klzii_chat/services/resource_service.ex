defmodule KlziiChat.Services.ResourceService do
  alias KlziiChat.{Repo, Topic, Resource, ResourceView}
  alias KlziiChat.Services.Permissions.Resources, as: ResourcePermissions

  import Ecto
  import Ecto.Query

  def get(topic_id, type, scope) do
    topic = Repo.get!(Topic, topic_id)
    resources = Repo.all(
      from e in assoc(topic, :resources),
        where: [type: ^type, scope: ^scope]
    )
    resp = Enum.map(resources, fn resource ->
      ResourceView.render("resource.json", %{resource: resource})
    end)

    {:ok, resp}
  end

  @spec deleteById(Map.t, Integer.t) :: {:ok, %{ id: Integer.t, replyId: Integer.t } } | {:error, String.t}
  def deleteById(session_member, id) do
    result = Repo.get_by!(Resource, id: id)
    if ResourcePermissions.can_delete(session_member, result) do
      case Repo.delete!(result) do
        {:error, error} -> # Something went wrong
          {:error, error}
        resource   -> # Deleted with success
          {:ok, resource  }
      end
    else
      {:error, "Action not allowed!"}
    end
  end
end
