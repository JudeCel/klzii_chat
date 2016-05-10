defmodule KlziiChat.Services.SessionResourcesServiceTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.SessionResourcesService

  setup %{session: session, member: member, account_user: account_user} do
    resource = Ecto.build_assoc(
      account_user.account, :resources,
      accountUserId: account_user.id,
      name: "TEST_IMG",
      type: "image",
      scope: "collage"
    ) |> Repo.insert!

    {:ok, session_id: session.id, member_id: member.id, resource_id: resource.id}
  end

  test "toggle", %{session_id: session_id, member_id: member_id, resource_id: resource_id} do
    SessionResourcesService.toggle(session_id, [resource_id], member_id)
  end
end
