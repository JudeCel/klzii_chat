defmodule KlziiChat.Services.SessionResourcesServiceTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.SessionResourcesService
  alias KlziiChat.SessionResource

  setup %{session: session, member: member, member2: member2, account_user: account_user} do
    img_resources = Enum.map(1..3, &create_image_resource(account_user, &1))
    img_resources_ids =
      Enum.map(img_resources, &Repo.insert(&1))
      |> Enum.map(fn({:ok, r}) -> r.id end)

    {:ok, session_id: session.id, member_id: member.id, member2_id: member2.id, resources_id: img_resources_ids}
  end

  test "toggle_add_3", %{session_id: session_id, member_id: member_id, resources_id: img_resources_ids} do
    SessionResourcesService.toggle(session_id, img_resources_ids, member_id)
    assert(getAllSessionRes(session_id) === img_resources_ids)
  end

  test "toggle_switch_2", %{session_id: session_id, member_id: member_id, resources_id: img_resources_ids} do
    SessionResourcesService.toggle(session_id, Enum.take(img_resources_ids, 2), member_id)
    SessionResourcesService.toggle(session_id, Enum.drop(img_resources_ids, 1), member_id)
    assert(getAllSessionRes(session_id) === Enum.drop(img_resources_ids, 1))
  end

  test "toggle_to_none", %{session_id: session_id, member_id: member_id, resources_id: img_resources_ids} do
    SessionResourcesService.toggle(session_id, img_resources_ids, member_id)
    SessionResourcesService.toggle(session_id, [], member_id)
    assert(getAllSessionRes(session_id) === [])
  end

  test "toggle_wrong_member_role_error", %{session_id: session_id, member2_id: member2_id, resources_id: img_resources_ids} do
    assert({:error, "Action not allowed!"} ===
      SessionResourcesService.toggle(session_id, img_resources_ids, member2_id))
  end

  test "delete_unused_session_resources_1", %{session_id: session_id, member_id: member_id, resources_id: img_resources_ids} do
    SessionResourcesService.toggle(session_id, img_resources_ids, member_id)
    used_res_id = [Enum.at(img_resources_ids, 1)]
    :ok = SessionResourcesService.delete_unused_session_resources(used_res_id, session_id)
    assert(getAllSessionRes(session_id) === used_res_id)
  end

  test "normalize_ids" do
    assert [] === SessionResourcesService.normalize_ids([])
    assert [1] === SessionResourcesService.normalize_ids([1])
    assert [1] === SessionResourcesService.normalize_ids(["1"])
    assert [1, 2, 3, 4] === SessionResourcesService.normalize_ids([1, "2", 3, "4"])
  end

  defp create_image_resource(account_user, n) do
    Ecto.build_assoc(
      account_user.account, :resources,
      accountUserId: account_user.id,
      name: "test image #{n}",
      type: "image",
      scope: "collage"
    )
  end

  defp getAllSessionRes(session_id) do
    from(sr in SessionResource, where: sr.sessionId == ^session_id, select: sr.resourceId)
    |> Repo.all()
  end
end
