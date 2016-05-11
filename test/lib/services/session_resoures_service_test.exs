defmodule KlziiChat.Services.SessionResourcesServiceTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.SessionResourcesService
  alias KlziiChat.SessionResource

  setup %{session: session, member: member, account_user: account_user} do
    imgResources = Enum.map(1..10, &genImgRes(account_user, &1))
    imgResIds =
      Enum.map(imgResources, &Repo.insert(&1))
      |> Enum.map(fn({:ok, r}) -> r.id end)

    {:ok, session_id: session.id, member_id: member.id, resources_id: imgResIds}
  end

  test "toggle", %{session_id: session_id, member_id: member_id, resources_id: imgResIds} do
    SessionResourcesService.toggle(session_id, Enum.take(imgResIds, 6), member_id)
    assert(getAllSessionRes(session_id) === Enum.take(imgResIds, 6))

    SessionResourcesService.toggle(session_id, Enum.drop(imgResIds, 4), member_id)
    assert(getAllSessionRes(session_id) === Enum.drop(imgResIds, 4))
  end

  defp genImgRes(account_user, n) do
    Ecto.build_assoc(
      account_user.account, :resources,
      accountUserId: account_user.id,
      name: "test image #{n}",
      type: "image",
      scope: "collage"
    )
  end

  defp getAllSessionRes(sessionId) do
    from(sr in SessionResource, where: sr.sessionId == ^sessionId, select: sr.resourceId)
    |> Repo.all()
  end
end
