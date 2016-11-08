defmodule KlziiChat.Services.SessionResourcesService do
  alias KlziiChat.{Repo, Resource, SessionResource, SessionMember, Console, SessionTopic}
  alias KlziiChat.Services.{ConsoleService}
  alias KlziiChat.Services.Permissions.SessionResources, as: SessionResourcesPermissions
  alias KlziiChat.Helpers.ListHelper
  alias KlziiChat.Queries.Resources, as: QueriesResources


  import Ecto.Query

  def add_session_resources(resource_ids, session_member_id) do
    session_member = Repo.get!(SessionMember, session_member_id)
    if(SessionResourcesPermissions.can_add_resources(session_member)) do
      do_add(session_member.sessionId, resource_ids)
    else
      {:error, %{permissions: "Action not allowed!"}}
    end
  end

  @spec do_add(Integer, Integer) :: {:ok, Map}
  defp do_add(session_id, resource_id) when is_integer(resource_id), do: do_add(session_id, [resource_id])

  @spec do_add(Integer, [Integer]) :: {:ok, Map}
  defp do_add(session_id, resource_ids) do
    sr_map =
      from(sr in SessionResource, where: sr.sessionId == ^session_id, select: sr.resourceId)
      |> Repo.all()
      |> ListHelper.find_diff_of_left(ListHelper.str_to_num(resource_ids))
      |> Enum.map(&%{resourceId: &1, sessionId: session_id, createdAt: Timex.now, updatedAt: Timex.now})

    {_, inserted_resources} = Repo.insert_all(SessionResource, sr_map, returning: true)
    {:ok, inserted_resources}
  end

  @spec delete(Integer, Integer) :: {:ok, %SessionResource{}} | {:error, String}
  def delete(session_member_id, session_resource_id) do
    session_member = Repo.get!(SessionMember, session_member_id)
    case SessionResourcesPermissions.can_get_resources(session_member) do
      {:ok} ->
        session_resource = Repo.get_by!(SessionResource, id: session_resource_id) |> Repo.preload([:resource]) |> Repo.delete!
        :ok = delete_related_consoles(session_resource.resource, session_member.id)
        {:ok, session_resource}
      {:error, reason} ->
        {:error, reason}
    end
  end


  @spec delete_related_consoles(%Resource{}, Integer) :: :ok
  def delete_related_consoles(resource, session_member_id) do
    session_member = Repo.get!(SessionMember, session_member_id)
    resource_id = resource.id
    session_topic_ids = from(st in SessionTopic, where: st.sessionId == ^session_member.sessionId, select: st.id) |> Repo.all
    from(c in Console,
      where: c.sessionTopicId in ^session_topic_ids,
      where:
        c.audioId == ^resource_id or
        c.videoId == ^resource_id or
        c.fileId == ^resource_id
      ) |> Repo.all
        |> ConsoleService.tidy_up(resource.type, session_member.id)
    :ok
  end

  def find(session_member_id, id) do
    session_member = Repo.get!(SessionMember, session_member_id)
    case SessionResourcesPermissions.can_get_resources(session_member) do
      {:ok} ->
        session_resource = from(sr in SessionResource,
          where: sr.id == ^id,
          preload: [:resource])
        |> Repo.one
        {:ok, session_resource}
      {:error, reason} ->
        {:error, reason}
    end
  end

  def get_session_resources(session_member_id, params) do
    session_member = Repo.get!(SessionMember, session_member_id) |> Repo.preload([account_user: [:account]])
    case SessionResourcesPermissions.can_get_resources(session_member) do
      {:ok} ->
        resource_query =
          QueriesResources.base_query
          |> QueriesResources.find_by_params(params)
          resource_ids = Repo.all(from r in resource_query, select: r.id)
          session_resources =
            from(sr in SessionResource,
              where: sr.sessionId == ^session_member.sessionId and
                sr.resourceId in ^resource_ids,
                preload: [:resource]
              )
            |> Repo.all
          {:ok, session_resources}
      {:error, reason} ->
        {:error, reason}
    end
  end
end
