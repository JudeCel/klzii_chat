defmodule KlziiChat.Services.SessionResourcesService do
  alias KlziiChat.{Endpoint, Repo, SessionResource, SessionMember, Console, ConsoleView, SessionTopic}
  alias KlziiChat.Services.{ConsoleService}
  alias KlziiChat.Services.Permissions.SessionResources, as: SessionResourcesPermissions
  alias KlziiChat.Helpers.ListHelper

  import Ecto.Query

  def add_session_resources(resource_ids, session_member_id) do
    session_member = Repo.get!(SessionMember, session_member_id)
    if(SessionResourcesPermissions.can_add_resources(session_member)) do
      do_add(session_member.sessionId, resource_ids)
    else
      {:error, "Action not allowed!"}
    end
  end

  @spec do_add(Integer, [Integer]) :: :ok
  defp do_add(session_id, resource_ids) do
    #TODO: replace insert with insert_all
    #createdAt: Timex.DateTime.now, updatedAt: Timex.DateTime.now

    session_resources = from(sr in SessionResource, where: sr.sessionId == ^session_id, select: sr.resourceId)
      |> Repo.all()
      |> ListHelper.find_diff(ListHelper.str_to_num(resource_ids))
      |> Enum.map(&Repo.insert!(%SessionResource{resourceId: &1, sessionId: session_id}))
      {:ok, session_resources}
  end

  def delete(session_member_id, session_resource_id) do
    session_member = Repo.get!(SessionMember, session_member_id)
    if(SessionResourcesPermissions.can_get_resources(session_member)) do
      session_resource = Repo.get_by!(SessionResource, id: session_resource_id) |> Repo.preload([:resource]) |> Repo.delete!
      delete_related_consoles(session_resource, session_member.id)
      {:ok, session_resource}
    else
      {:error, "Action not allowed!"}
    end
  end


  def delete_related_consoles(session_resource, session_member_id) do
    session_member = Repo.get!(SessionMember, session_member_id)
    session_id = session_member.sessionId
    session_topicIds = from(st in SessionTopic, where: st.sessionId == ^session_id, select: st.id) |> Repo.all
    consoles = from(c in Console,
      where: c.sessionTopicId in ^session_topicIds,
      where:
        c.audioId == ^session_resource.resourceId or
        c.videoId == ^session_resource.resourceId or
        c.imageId == ^session_resource.resourceId or
        c.fileId == ^session_resource.resourceId,
      preload: [:sessionTopic]
      ) |> Repo.all
        |> Enum.map(fn console ->
          {:ok, new_console} = ConsoleService.remove_resource(session_member.id, console.sessionTopic.topicId, session_resource.resource.type)
          data = ConsoleView.render("show.json", %{console: new_console})
          Endpoint.broadcast!( "topics:#{console.sessionTopic.topicId}", "console", data)
      end)
  end

  def get_session_resources(session_member_id) do
    session_member = Repo.get!(SessionMember, session_member_id)
    if(SessionResourcesPermissions.can_get_resources(session_member)) do
      do_get(session_member.sessionId)
    else
      {:error, "Action not allowed!"}
    end
  end

  defp do_get(session_id) do
    session_resources = from(sr in SessionResource,
      where: sr.sessionId == ^session_id,
      preload: [:resource])
    |> Repo.all()
    {:ok, session_resources}
  end
end
