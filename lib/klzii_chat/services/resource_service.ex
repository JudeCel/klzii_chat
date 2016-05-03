defmodule KlziiChat.Services.ResourceService do
  alias KlziiChat.{Repo, AccountUser, Resource, ResourceView, User}
  alias KlziiChat.Services.Permissions.Resources, as: ResourcePermissions
  alias KlziiChat.Queries.Resources, as: QueriesResources

  import Ecto
  import Ecto.Query


  def upload(params, account_user_id)  do
    account_user = Repo.get!(AccountUser, account_user_id) |> Repo.preload([:account])
    if account_user.role == "admin" do
      Map.put(params, "private", (params["private"] || false))
    else
      Map.put(params, "private", false)
    end |> save_resource(account_user)
  end

  def save_resource(%{"private" => private, "type" => type, "scope" => scope, "file" => file, "name"=> name}, account_user) do
    params = %{
      type: type,
      scope: scope,
      accountId: account_user.account.id,
      accountUserId: account_user.id,
      type: type,
      name: name,
      private: private
    } |> Map.put(String.to_atom(type), file)
    changeset = Resource.changeset(%Resource{}, params)

    case Repo.insert(changeset) do
      {:ok, resource} ->
        {:ok, resource}
      {:error, reason} ->
        {:error, reason}
    end
  end

  def get(account_user_id, type) do
    account_user = Repo.get!(AccountUser, account_user_id)
      |> Repo.preload([:account])
      resources =
        QueriesResources.add_role_scope(account_user)
        |> where(type: ^type)
        |> Repo.all
        |> Phoenix.View.render_many( ResourceView, "resource.json")
    {:ok, resources}
  end

  def find(account_user_id, id) do
    account_user = Repo.get!(AccountUser, account_user_id)
      |> Repo.preload([:account])
    resource =
      QueriesResources.add_role_scope(account_user)
      |> where([r], r.id in ^[id])
      |> Repo.one
    {:ok, resource}
  end

  @spec deleteByIds(Integer.t, List.t) :: {:ok, %Resource{} } | {:error, String.t}
  def deleteByIds(account_user_id, ids) do
    account_user = Repo.get!(AccountUser, account_user_id) |> Repo.preload([:account])

    query = QueriesResources.add_role_scope(account_user) |> where([r], r.id in ^ids)
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

  def daily_cleanup do
    from(e in Resource,
      where: e.expiryDate < ^Timex.DateTime.now,
      where: e.type == "file",
      where: e.scope == "zip")
    |> Repo.delete_all
  end

  @spec create_new_zip(Integer.t, String.t, List.t) :: {:ok, %Resource{} } | %{status: :error, reason: String.t}
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
        status: "progress",
        expiryDate: Timex.DateTime.now |> Timex.shift(days: 1),
        properties: %{zip_ids: ids}
      )

      case Repo.insert(changeset) do
        {:ok, resource} ->
          Task.async(fn -> KlziiChat.Files.Tasks.run(resource, ids) end)
          |> Task.await

          {:ok, resource }
        {:error, reason} ->
          {:error, reason}
      end
    else
      {:error, "Action not allowed!"}
    end
  end
end
