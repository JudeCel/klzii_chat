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

  def find(account_user_id, id) do
    account_user = Repo.get!(AccountUser, account_user_id)
      |> Repo.preload([:account])
    resource = Repo.one(
      from r in assoc(account_user.account, :resources),
        where: r.id in ^[id]
    )
    {:ok, resource}
  end

  @spec deleteByIds(Integer.t, List.t) :: {:ok, %Resource{} } | {:error, String.t}
  def deleteByIds(account_user_id, ids) do
    account_user = Repo.get!(AccountUser, account_user_id) |> Repo.preload([:account])
    query =
      from e in assoc(account_user.account, :resources),
      where: e.id in ^ids
    result = Repo.all(query)

    if ResourcePermissions.can_delete(account_user, result) do
      case Repo.delete_all(query) do
        {:error, error} ->
          {:error, error}
        {count, nil} ->
          {:ok, result}
      end
    else
      {:error, "Action not allowed!"}
    end
  end

  @spec create_new_zip(%User{}, String.t, List.t) :: {:ok, %Resource{} } | %{status: :error, reason: String.t}
  def create_new_zip(account_user_id, name, ids) do
    account_user = Repo.get!(AccountUser, account_user_id) |> Repo.preload([:account])
    query =
      from e in assoc(account_user.account, :resources),
      where: e.id in ^ids,
      where: e.type in ~w(image audio file video)
    result = Repo.all(query)

    if ResourcePermissions.can_zip(account_user, result) do
      changeset = Ecto.build_assoc(
        account_user.account, :resources,
        accountUserId: account_user.id,
        scope: "zip",
        type: "file",
        name: name,
        status: "progress"
      )

      case Repo.insert(changeset) do
        {:ok, resource} ->
          {:ok, resource }
        {:error, reason} ->
          {:error, reason}
      end
    else
      {:error, "Action not allowed!"}
    end
  end
end
