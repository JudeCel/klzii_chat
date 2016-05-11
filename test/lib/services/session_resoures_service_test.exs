defmodule KlziiChat.Services.SessionResourcesServiceTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.SessionResourcesService
  alias KlziiChat.SessionResource

  setup %{session: session, member: member, account_user: account_user} do
    image_resource = Ecto.build_assoc(
      account_user.account, :resources,
      accountUserId: account_user.id,
      name: "cool image",
      type: "image",
      scope: "collage"
    ) |> Repo.insert!

    {:ok, session_id: session.id, member_id: member.id, resource_id: image_resource.id}
  end

  test "toggle", %{session_id: session_id, member_id: member_id, resource_id: resource_id} do
    SessionResourcesService.toggle(session_id, [resource_id], member_id)

    res =
      from(sr in SessionResource, where: sr.sessionId == ^session_id, select: sr.resourceId)
      |> Repo.all()

    assert(res = [resource_id])
  end
end
