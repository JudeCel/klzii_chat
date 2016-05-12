defmodule KlziiChat.Services.SessionResourcesServiceTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.SessionResourcesService
  alias KlziiChat.SessionResource

  setup %{session: session, member: member, member2: member2, account_user: account_user} do
    img_resources = Enum.map(1..3, &create_image_resource(account_user, &1))
    img_resource_ids =
      Enum.map(img_resources, &Repo.insert(&1))
      |> Enum.map(fn({:ok, r}) -> r.id end)

    {:ok, session_id: session.id, member_id: member.id, member2_id: member2.id, resource_ids: img_resource_ids}
  end

  test "add_resources", %{session_id: session_id, member_id: member_id, resource_ids: img_resource_ids} do
    :ok = SessionResourcesService.add_session_resources(session_id, img_resource_ids, member_id)
    assert(getAllSessionResIds(session_id) === img_resource_ids)
  end

  test "add_wrong_member_role_error", %{session_id: session_id, member2_id: member2_id, resource_ids: img_resource_ids} do
    assert({:error, "Action not allowed!"} ===
      SessionResourcesService.add_session_resources(session_id, img_resource_ids, member2_id))
  end


  test "delete_session_resource", %{session_id: session_id, member_id: member_id, resource_ids: img_resource_ids} do
    :ok = SessionResourcesService.add_session_resources(session_id, img_resource_ids, member_id)
    :ok = SessionResourcesService.delete_session_resource(session_id, List.first(img_resource_ids), member_id)
    assert(getAllSessionResIds(session_id) === Enum.drop(img_resource_ids, 1))
  end

  test "delete_wrong_member_role_error", %{session_id: session_id, member2_id: member2_id, resource_ids: img_resource_ids} do
    assert({:error, "Action not allowed!"} ===
      SessionResourcesService.delete_session_resource(session_id, img_resource_ids, member2_id))
  end


  test "get_sesion_resources", %{session_id: session_id, member_id: member_id, resource_ids: img_resource_ids} do
    :ok = SessionResourcesService.add_session_resources(session_id, img_resource_ids, member_id)
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
