defmodule KlziiChat.Services.ResourceService do
  alias KlziiChat.{Repo, AccountUser, Resource, ResourceView}
  alias KlziiChat.Services.Permissions.Resources, as: ResourcePermissions
  alias KlziiChat.Queries.Resources, as: QueriesResources

  import Ecto
  import Ecto.Query

  @spec upload(map, integer) ::  {:ok, %Resource{}} | {:error, map}
  def upload(params, account_user_id)  do
    account_user = Repo.get!(AccountUser, account_user_id) |> Repo.preload([:account])
    if account_user.role == "admin" do
      Map.put(params, "private", (params["private"] || false))
    else
      Map.put(params, "private", false)
    end |> save_resource(account_user)
  end

  @spec validate(map, map) :: {:ok} | {:error, map}
  def validate(file, params) do
    validate_file_type(file, params)
  end

  @spec validate_file_type(map | String.t, map) :: {:ok} | {:error, map}
  def validate_file_type(file, params) when is_map(file) do
    file_type = String.split(file.content_type, "/") |> List.first
    cond do
      file_type != params.type ->
        {:error, %{code: 415, type: "You are trying to upload #{file_type} where it is allowed only #{params.type}."}}
      true ->
        {:ok}
    end
  end
  def validate_file_type(file, params) when is_bitstring(file) do
    cond do
      params.type in ["file", "link"] ->
        {:ok}
      true ->
        {:error, %{code: 415, type: "Accept only links"}}
    end
  end
  def validate_file_type(_, _) do
    {:error, %{code: 415, type: "File not valid"}}
  end

  @spec save_resource(map, integer) :: {:ok, %Resource{}} | {:error, map}
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

    case validate(file, params) do
      {:ok} ->
        Resource.changeset(%Resource{}, params)
        |> Repo.insert
        |> case do
            {:ok, resource} ->
              {:ok, resource}
            {:error, reason} ->
              {:error, Map.put(reason, :code, 400)}
           end
      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec get(integer, String.t) :: {:ok, list}
  def get(account_user_id, type) do
    account_user = Repo.get!(AccountUser, account_user_id)
      |> Repo.preload([:account])
      resources =
        QueriesResources.base_query(account_user)
        |> where(type: ^type)
        |> Repo.all
        |> Phoenix.View.render_many( ResourceView, "resource.json")
    {:ok, resources}
  end

  @spec find(integer, integer) :: {:ok, list}
  def find(account_user_id, id) do
    account_user = Repo.get!(AccountUser, account_user_id)
      |> Repo.preload([:account])
    resource =
      QueriesResources.base_query(account_user)
      |> where([r], r.id in ^[id])
      |> Repo.one
    {:ok, resource}
  end

  @spec deleteByIds(Integer.t, List.t) :: {:ok, %Resource{} } | {:error, String.t}
  def deleteByIds(account_user_id, ids) do
    account_user = Repo.get!(AccountUser, account_user_id) |> Repo.preload([:account])

    query = QueriesResources.base_query(account_user) |> where([r], r.id in ^ids)
    result = Repo.all(query)

    case ResourcePermissions.can_delete(account_user, result) do
      {:ok} ->
        case Repo.delete_all(query) do
          {:error, error} ->
            {:error, error}
          {_count, nil} ->
            {:ok, result}
        end
      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec daily_cleanup() :: {:ok, list}
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

    case ResourcePermissions.can_zip(account_user, result) do
      {:ok} ->
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
            {:ok, resource }
          {:error, reason} ->
            {:error, Map.put(reason, :code, 400)}
        end
      {:error, reason} ->
        {:error, reason}
    end
  end
end
