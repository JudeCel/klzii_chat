defmodule KlziiChat.Services.SessionResourcesService do
  alias KlziiChat.{Repo, SessionResource, SessionMember}
  alias KlziiChat.Services.Permissions.SessionResources, as: SessionResourcesPermissions
  alias KlziiChat.Helpers.ListHelper

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

  @spec do_add(Integer, [Integer]) :: :ok
  defp do_add(session_id, resource_ids) do
    #TODO: replace insert with insert_all
    #createdAt: Timex.DateTime.now, updatedAt: Timex.DateTime.now

    sr_map =
      from(sr in SessionResource, where: sr.sessionId == ^session_id, select: sr.resourceId)
      |> Repo.all()
      |> ListHelper.find_diff(ListHelper.str_to_num(resource_ids))
      |> Enum.map(&%{resourceId: &1, sessionId: session_id, createdAt: DateTime.now, updatedAt: DateTime.now})

    {_, inserted_resources} = Repo.insert_all(SessionResource, sr_map, returning: [:resourceId, :sessionId, :id])
    {:ok, inserted_resources}
  end

  def delete(session_member_id, session_resource_id) do
    session_member = Repo.get!(SessionMember, session_member_id)
    if(SessionResourcesPermissions.can_get_resources(session_member)) do
      result = Repo.get_by!(SessionResource, id: session_resource_id) |> Repo.delete!
      {:ok, result}
    else
      {:error, "Action not allowed!"}
    end
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
