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
    :ok = SessionResourcesService.toggle(session_id, img_resources_ids, member_id)
    assert(getAllSessionResIds(session_id) === img_resources_ids)
  end

  test "toggle_switch_2", %{session_id: session_id, member_id: member_id, resources_id: img_resources_ids} do
    :ok = SessionResourcesService.toggle(session_id, Enum.take(img_resources_ids, 2), member_id)
    :ok = SessionResourcesService.toggle(session_id, Enum.drop(img_resources_ids, 1), member_id)
    assert(getAllSessionResIds(session_id) === Enum.drop(img_resources_ids, 1))
  end

  test "toggle_to_none", %{session_id: session_id, member_id: member_id, resources_id: img_resources_ids} do
    :ok = SessionResourcesService.toggle(session_id, img_resources_ids, member_id)
    :ok = SessionResourcesService.toggle(session_id, [], member_id)
    assert(getAllSessionResIds(session_id) === [])
  end

  test "toggle_wrong_member_role_error", %{session_id: session_id, member2_id: member2_id, resources_id: img_resources_ids} do
    assert({:error, "Action not allowed!"} ===
      SessionResourcesService.toggle(session_id, img_resources_ids, member2_id))
  end

  test "delete_unused_session_resources_1", %{session_id: session_id, member_id: member_id, resources_id: img_resources_ids} do
    :ok = SessionResourcesService.toggle(session_id, img_resources_ids, member_id)
    used_res_id = [Enum.at(img_resources_ids, 1)]
    :ok = SessionResourcesService.delete_unused_session_resources(used_res_id, session_id)
    assert(getAllSessionResIds(session_id) === used_res_id)
  end

  test "get_sesion_resources", %{session_id: session_id, member_id: member_id, resources_id: img_resources_ids} do
    :ok = SessionResourcesService.toggle(session_id, img_resources_ids, member_id)
    {:ok, session_resources_ids} = SessionResourcesService.get_session_resources(session_id, member_id)
    assert(session_resources_ids === getAllSessionRes(session_id))
  end

  test "get_sesion_resources_wrong_member_role_error", %{session_id: session_id, member2_id: member2_id} do
    assert({:error, "Action not allowed!"} ===
      SessionResourcesService.get_session_resources(session_id, member2_id))
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
    from(sr in SessionResource, where: sr.sessionId == ^session_id, preload: [:resource])
    |> Repo.all()
  end

  defp getAllSessionResIds(session_id) do
    from(sr in SessionResource, where: sr.sessionId == ^session_id, select: sr.resourceId)
    |> Repo.all()
  end
end
