defmodule KlziiChat.Services.SessionResourcesService do
  alias KlziiChat.{Repo, SessionResource}

  import Ecto
  import Ecto.Query

  def toggle(sessionId, resourcesIds, sessionMemberId) do
    # remove all unseleted resources
    from(sr in SessionResource, where: not sr.resourceId in ^resourcesIds and sr.sessionId == ^sessionId)
    |> Repo.delete_all()

    # id's of the resources left
    srIds =
      from(sr in SessionResource, where: sr.sessionId == ^sessionId, select: sr.resourceId)
      |> Repo.all()

    # add all new resoures that are unique
    Stream.filter(resourcesIds, &(not &1 in srIds))
    |> Enum.each(&Repo.insert(%SessionResource{resourceId: &1, sessionId: sessionId}))

    #newSR = Enum.map(resourcesIds, &(%{resourceId: &1, sessionId: sessionId}))
    #Repo.insert_all("SessionResources", newSR)
  end
end
