defmodule KlziiChat.Services.SessionResourcesService do
  alias KlziiChat.{Repo, SessionResource, SessionMember}
  alias KlziiChat.Services.Permissions.SessionResources, as: SessionResourcesPermissions
  alias KlziiChat.Helpers.ListHelper

  import Ecto.Query

  def toggle(session_id, resources_ids, session_member_id) do
    session_member = Repo.get!(SessionMember, session_member_id)
    if(SessionResourcesPermissions.can_toggle_resources(session_member)) do
      do_toggle(session_id, resources_ids)
    else
      {:error, "Action not allowed!"}
    end
  end

  @spec do_toggle(Integer, [Integer]) :: Map
  def do_toggle(session_id, resources_ids) do
    :ok = delete_unused_session_resources(resources_ids, session_id)

    #TODO: replace insert with insert_all

    from(sr in SessionResource,
      where: sr.sessionId == ^session_id,
      select: sr.resourceId)
    |> Repo.all()
    |> ListHelper.find_diff(ListHelper.str_to_num(resources_ids))
    |> Enum.map(&Repo.insert(%SessionResource{resourceId: &1, sessionId: session_id}))
    |> Enum.map(fn({:ok, r}) -> r.id end)
  end

  def delete_unused_session_resources(resources_ids, session_id) do
    from(sr in SessionResource,
      where: not sr.resourceId in ^resources_ids and sr.sessionId == ^session_id)
    |> Repo.delete_all()

    :ok
  end
end
