defmodule KlziiChat.Services.ResourceService do
  alias KlziiChat.{Repo, AccountUser, Resource, ResourceView, User}
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

  @spec deleteByIds(Integer.t, List.t) :: {:ok, %Resource{} } | {:error, String.t}
  def deleteByIds(account_user_id, ids) do
    account_user = Repo.get!(AccountUser, account_user_id) |> Repo.preload([:account])
    result = Repo.all(
      from e in assoc(account_user.account, :resources),
      where: e.id in ^ids
    )
    if ResourcePermissions.can_delete(account_user, result) do
      case Repo.delete!(result) do
        {:error, error} ->
          {:error, error}
        resources ->
          {:ok, resources}
      end
    else
      {:error, "Action not allowed!"}
    end
  end

  @spec create_new_zip(%User{}, String.t, List.t) :: {:ok, %Resource{} } | %{status: :error, reason: String.t}
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
        {:ok, resource }
      {:error, reason} ->
        {:error, reason}
    end
  end
end
