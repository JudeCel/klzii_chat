defmodule KlziiChat.Services.SessionResourcesService do
  alias KlziiChat.{Endpoint, Repo, Resource, SessionResource, SessionMember, Console, ConsoleView, SessionTopic}
  alias KlziiChat.Services.{ConsoleService}
  alias KlziiChat.Services.Permissions.SessionResources, as: SessionResourcesPermissions
  alias KlziiChat.Helpers.ListHelper
  alias KlziiChat.Queries.Resources, as: QueriesResources

  use Timex

  import Ecto.Query

  def add_session_resources(resource_ids, session_member_id) do
    session_member = Repo.get!(SessionMember, session_member_id)
    if(SessionResourcesPermissions.can_add_resources(session_member)) do
      do_add(session_member.sessionId, resource_ids)
    else
      {:error, "Action not allowed!"}
    end
  end

  @spec do_add(Integer, Integer) :: {:ok, Map}
  defp do_add(session_id, resource_id) when is_integer(resource_id), do: do_add(session_id, [resource_id])

  @spec do_add(Integer, [Integer]) :: {:ok, Map}
  defp do_add(session_id, resource_ids) do
    sr_map =
      from(sr in SessionResource, where: sr.sessionId == ^session_id, select: sr.resourceId)
      |> Repo.all()
      |> ListHelper.find_diff(ListHelper.str_to_num(resource_ids))
      |> Enum.map(&%{resourceId: &1, sessionId: session_id, createdAt: DateTime.now, updatedAt: DateTime.now})

    {_, inserted_resources} = Repo.insert_all(SessionResource, sr_map, returning: [:resourceId, :sessionId, :id])
    {:ok, inserted_resources}
  end

  @spec delete(Integer, Integer) :: {:ok, %SessionResource{}} | {:error, String}
  def delete(session_member_id, session_resource_id) do
    session_member = Repo.get!(SessionMember, session_member_id)
    if(SessionResourcesPermissions.can_get_resources(session_member)) do
      session_resource = Repo.get_by!(SessionResource, id: session_resource_id) |> Repo.preload([:resource]) |> Repo.delete!
      :ok = delete_related_consoles(session_resource.resource, session_member.id)
      {:ok, session_resource}
    else
      {:error, "Action not allowed!"}
    end
  end


  @spec delete_related_consoles(%Resource{}, Integer) :: :ok
  def delete_related_consoles(resource, session_member_id) do
    session_member = Repo.get!(SessionMember, session_member_id)
    resourceId = resource.id
    session_topicIds = from(st in SessionTopic, where: st.sessionId == ^session_member.sessionId, select: st.id) |> Repo.all
    from(c in Console,
      where: c.sessionTopicId in ^session_topicIds,
      where:
        c.audioId == ^resourceId or
        c.videoId == ^resourceId or
        c.imageId == ^resourceId or
        c.fileId == ^resourceId,
      preload: [:sessionTopic]
      ) |> Repo.all
        |> Enum.map(fn console ->
          {:ok, new_console} = ConsoleService.remove_resource(session_member.id, console.sessionTopic.topicId, resource.type)
          data = ConsoleView.render("show.json", %{console: new_console})
          Endpoint.broadcast!( "topics:#{console.sessionTopic.topicId}", "console", data)
      end)
      :ok
  end

  def find(session_member_id, id) do
    session_member = Repo.get!(SessionMember, session_member_id)
    if(SessionResourcesPermissions.can_get_resources(session_member)) do
      session_resource = from(sr in SessionResource,
        where: sr.id == ^id,
        preload: [:resource])
      |> Repo.one
      {:ok, session_resource}
    else
      {:error, "Action not allowed!"}
    end
  end

  def get_session_resources(session_member_id, params) do
    session_member = Repo.get!(SessionMember, session_member_id) |> Repo.preload([account_user: [:account]])
    if(SessionResourcesPermissions.can_get_resources(session_member)) do
      resource_query =
        QueriesResources.base_query(session_member.account_user)
        |> QueriesResources.find_by_params(params)
        session_resources =
          from(sr in SessionResource, where: sr.sessionId == ^session_member.sessionId, preload: [resource: ^resource_query])
          |> Repo.all
        {:ok, session_resources}
    else
      {:error, "Action not allowed!"}
    end
  end

end
