defmodule KlziiChat.Services.SessionResourcesService do
  alias KlziiChat.{Repo, SessionResource, SessionMember}
  alias KlziiChat.Services.UnreadMessageService
  alias KlziiChat.Services.Permissions.Session, as: SessionPermissions

  import Ecto.Query

  def toggle(session_id, resources_ids, session_member_id) do
    session_member = Repo.get!(SessionMember, session_member_id)
    if(SessionPermissions.can_toggle_resources(session_member)) do
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
    |> UnreadMessageService.find_diff(normalize_ids(resources_ids))
    |> Enum.map(&Repo.insert(%SessionResource{resourceId: &1, sessionId: session_id}))
    |> Enum.map(fn({:ok, r}) -> r.id end)
  end

  def delete_unused_session_resources(resources_ids, session_id) do
    from(sr in SessionResource,
      where: not sr.resourceId in ^resources_ids and sr.sessionId == ^session_id)
    |> Repo.delete_all()

    :ok
  end

  def normalize_ids(ids) do
    Enum.map(ids, &get_normalized/1)
  end

  defp get_normalized(id) when is_integer(id), do: id

  defp get_normalized(id) when is_bitstring(id) do
    {num_id, ""} = Integer.parse(id)
    num_id
  end
end
