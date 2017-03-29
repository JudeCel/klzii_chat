defmodule KlziiChat.Services.ResourceService do
  alias KlziiChat.{Repo, AccountUser, Resource, ResourceView, Session}
  alias KlziiChat.Services.Permissions.Resources, as: ResourcePermissions
  alias KlziiChat.Queries.Resources, as: QueriesResources
  alias KlziiChat.Services.Validations.Resource, as: ResourceValidations
  alias KlziiChat.Services.{SessionReportingService}

  import Ecto.Query

  @spec recalculate_all_images() ::  {:ok}
  def recalculate_all_images() do
    from(r in Resource, where: [type: "image"])
    |> Repo.all()
    |> Enum.each(&(resave_resource(&1)))
    {:ok}
  end

  def resave_resource(item) do
    type = item.type
    uploader = get_uploader(type)

    if field = Map.get(item, String.to_atom(type)) do
      extname = Map.get(field, :file_name)
      |> Path.extname
      Enum.each(uploader.versions, fn version ->
        url = uploader.url({item.type, item}, version) <> extname
        uploader.store({url, item})
      end)
    end
  end

  @spec upload(map, integer) ::  {:ok, %Resource{}} | {:error, map}
  def upload(params, account_user_id)  do
    account_user = Repo.get!(AccountUser, account_user_id) |> Repo.preload([:account])
    case ResourcePermissions.can_upload_by_scope(account_user, Map.get(params, "scope")) do
      {:ok} ->
        if account_user.role == "admin" do
          Map.put(params, "stock", (params["stock"] || false))
        else
          Map.put(params, "stock", false)
          |> Map.delete("id")
        end
        |> save_resource(account_user)
      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec save_resource(map, integer) :: {:ok, %Resource{}} | {:error, map}
  def save_resource(%{"stock" => stock, "type" => type, "scope" => scope, "file" => file, "name" => name, "id" => id}, account_user) do
    params = %{
      type: type,
      scope: scope,
      accountId: account_user.account.id,
      accountUserId: account_user.id,
      type: type,
      name: name,
      stock: stock,
      id: id
    }

    with {:ok} <- ResourceValidations.validate(file, params),
      {:ok, resource} <- find(account_user.id, id),
      {:ok, updated_resource} <- update_recource(Resource.changeset(resource, params)),
      {:ok, result} <- replace_resource_file(updated_resource, file),
    do: {:ok, result}
  end

  def save_resource(%{"stock" => stock, "type" => type, "scope" => scope, "file" => file, "name" => name}, account_user) do
    params = %{
      type: type,
      scope: scope,
      accountId: account_user.account.id,
      accountUserId: account_user.id,
      type: type,
      name: name,
      stock: stock
    }

    with {:ok} <- ResourceValidations.validate(file, params),
      {:ok, resource} <- insert_recource(Resource.changeset(%Resource{}, params)),
      {:ok, result} <- add_file(resource, file),
    do: {:ok, result}
  end

  @spec insert_recource(%Resource{}) :: {:ok, %Resource{}} | {:error, map}
  defp insert_recource(resource) do
    Repo.insert(resource)
    |> case do
        {:ok, resource } ->
          {:ok, resource}
        {:error, reason} ->
          {:error, Map.put(reason, :code, 400)}
       end
  end

  @spec update_recource(%Resource{}) :: {:ok, %Resource{}} | {:error, map}
  defp update_recource(resource) do
    Repo.update(resource)
    |> case do
        {:ok, resource } ->
          {:ok, resource}
        {:error, reason} ->
          {:error, Map.put(reason, :code, 400)}
       end
  end

  @spec replace_resource_file(%Resource{}, map) :: {:ok, %Resource{}} | {:error, map}
  defp replace_resource_file(resource, file) do
    :ok = clean_up([resource])
    add_file(resource, file)
  end

  @spec add_file(%Resource{}, map) :: {:ok, %Resource{}} | {:error, map}
  def add_file(resource, file) do
    Resource.changeset(resource, %{String.to_atom(resource.type) => file})
    |> Repo.update
    |> case do
        {:ok, resource } ->
          {:ok, resource}
        {:error, reason} ->
          Repo.delete(resource)
          {:error, Map.put(reason, :code, 400)}
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
    Repo.get!(AccountUser, account_user_id)
      |> Repo.preload([:account])
      |> QueriesResources.by_account_or_stock_query
      |> QueriesResources.get_by_ids([id])
      |> Repo.one
      |> case  do
          nil ->
            {:error, %{code: 404, not_found: "Resource not found"}}
          resource ->
            {:ok, resource}
        end
  end

  @spec find_by_session(integer, integer) :: {:ok, list}
  def find_by_session(session_id, id) do
    Repo.get!(Session, session_id)
      |> Repo.preload([:account])
      |> QueriesResources.by_account_or_stock_query
      |> QueriesResources.get_by_ids([id])
      |> Repo.one
      |> case  do
          nil ->
            {:error, %{code: 404, not_found: "Resource not found"}}
          resource ->
            {:ok, resource}
        end
  end

  def validations(account_user, query) do
    with result <- Repo.all(query),
         {:ok} <- ResourcePermissions.can_delete(account_user, result),
    do: {:ok, result}
  end

  @spec closed_session_delete_check_by_ids(Integer.t, List.t) :: {:ok, %Resource{} } | {:error, String.t}
  def closed_session_delete_check_by_ids(account_user_id, ids) do
    account_user = Repo.get!(AccountUser, account_user_id) |> Repo.preload([:account])
    query = QueriesResources.base_query(account_user)
      |> QueriesResources.get_by_ids(ids)
      |> QueriesResources.where_stock(false)

    case validations(account_user, query) do
      {:ok, _} ->
        items = QueriesResources.get_by_ids_for_closed_session(ids) |> Repo.all
        {:ok, items}
      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec deleteByIds(Integer.t, List.t) :: {:ok, %Resource{} } | {:error, String.t}
  def deleteByIds(account_user_id, ids) do
    account_user = Repo.get!(AccountUser, account_user_id) |> Repo.preload([:account])
    query = QueriesResources.base_query(account_user)
      |> QueriesResources.get_by_ids(ids)
      |> QueriesResources.where_stock(false)

    case validations(account_user, query) do
      {:ok, _} ->
        deleteByIds(ids)
      {:error, reason} ->
        {:error, reason}
    end
  end

  def deleteByIds(ids) do
    {:ok, query, stock, used} = get_delete_by_ids_data(ids)

    result = Repo.all(query)
    KlziiChat.BackgroundTasks.Resources.tidy_up(result)

    {:ok, result, stock, used}
  end

  def clean_up_all_relations(resource) do
    SessionReportingService.clean_up_by_resource_ids([resource.id])
    Repo.delete!(resource)
    clean_up([resource])
  end

  defp get_delete_by_ids_data(ids) do
    stock = QueriesResources.base_query
      |> QueriesResources.get_by_ids(ids)
      |> QueriesResources.where_stock(true)
      |> Repo.all

    used = QueriesResources.get_by_ids_used(ids)
      |> Repo.all

    query = QueriesResources.base_query
      |> QueriesResources.get_by_ids(ids)
      |> QueriesResources.where_stock(false)
      |> QueriesResources.exclude(used)

    {:ok, query, stock, used}
  end

  @spec clean_up(list) :: :ok
  def clean_up(list) do
    Enum.map(list, fn(item) ->
      type = item.type
      uploader = get_uploader(type)

      if field = Map.get(item, String.to_atom(type)) do
        extname = Map.get(field, :file_name)
        |> Path.extname
        Enum.map(uploader.versions, fn version ->
          url = uploader.url({item.type, item}, version) <> extname
          uploader.delete({url, item})
        end)
      end
    end)
    :ok
  end

  @spec get_uploader(String.t) ::
    KlziiChat.Uploaders.Image |
    KlziiChat.Uploaders.File |
    KlziiChat.Uploaders.Audio |
    KlziiChat.Uploaders.Video
  def get_uploader(type) do
    module_refix = "KlziiChat.Uploaders."
    {module_path, _} = Code.eval_string(module_refix <> String.capitalize(type))
    case Code.ensure_loaded(module_path) do
      {:module, module} ->
        module
      {:error, :nofile} ->
        raise("Uploader module not found #{module_path}")
    end
  end

  @spec daily_cleanup() :: {:ok, list}
  def daily_cleanup do
    from(e in Resource,
      where: e.expiryDate < ^Timex.now,
      where: e.type == "file",
      where: e.scope == "zip")
    |> Repo.delete_all
  end
end
