defmodule KlziiChat.Services.SessionResourcesService do
  alias KlziiChat.{Repo, SessionResource}
  alias KlziiChat.Services.UnreadMessageService

  import Ecto
  import Ecto.Query

  @spec toggle(Integer, [Integer], Integer) :: Map
  def toggle(session_id, resources_ids, session_member_id) do
    :ok = delete_session_resources(resources_ids, session_id)

    #TODO: replace insert with insert_all

    from(sr in SessionResource,
      where: sr.sessionId == ^session_id,
      select: sr.resourceId)
    |> Repo.all()
    |> UnreadMessageService.find_diff(normalize_ids(resources_ids))
    |> Enum.map(&Repo.insert(%SessionResource{resourceId: &1, sessionId: session_id}))
  end

  def delete_session_resources(resources_ids, session_id) do
    from(sr in SessionResource,
      where: not sr.resourceId in ^resources_ids and sr.sessionId == ^session_id)
    |> Repo.delete_all()

    :ok
  end

  def normalize_ids(ids) do
    Enum.map(ids, fn(id) ->
      if(is_bitstring(id)) do
        {num_id, ""} = Integer.parse(id)
        num_id
      else
        id
      end
    end)
  end

end
