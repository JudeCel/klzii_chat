defmodule KlziiChat.Services.ResourceService do
  alias KlziiChat.{Repo, AccountUser, Resource, ResourceView}
  alias KlziiChat.Services.Permissions.Resources, as: ResourcePermissions

  import Ecto
  import Ecto.Query

  def get(account_user_id, type) do
    account_user = Repo.get!(AccountUser, account_user_id)
      |> Repo.preload([:account])
    resources = Repo.all(
      from e in assoc(account_user.account, :resources),
        where: [type: ^type]
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

  def create_new_zip(user, name, _ids) do
    params = %{
      scope: "zip",
      accountId: user.account.id,
      accountUserId: user.id,
      type: "zip",
      name: name,
      status: "progress"
    }
    changeset = Resource.changeset(%Resource{}, params)

    case Repo.insert(changeset) do
      {:ok, resource} ->
        %{type: resource.type, resources: [ ResourceView.render("resource.json", %{resource: resource}) ] }
      {:error, reason} ->
        %{status: :error, reason: reason}
    end
  end
end
