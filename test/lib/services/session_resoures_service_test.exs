defmodule KlziiChat.Services.SessionResourcesServiceTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.SessionResourcesService
  alias KlziiChat.SessionResource

  setup %{session: session, member: member, member2: member2, account_user: account_user} do
    img_resources = Enum.map(1..3, &create_image_resource(account_user, &1))
    img_resource_ids =
      Enum.map(img_resources, &Repo.insert!(&1))
      |> Enum.map(fn(r) -> r.id end)

    {:ok, session_id: session.id, member_id: member.id, member2_id: member2.id, resource_ids: img_resource_ids}
  end

  test "add_resources", %{member_id: member_id, resource_ids: img_resource_ids} do
    {:ok, resp} = SessionResourcesService.add_session_resources(img_resource_ids, member_id)
    last = List.last(resp)
    Repo.get!(SessionResource, last.id)
  end

  test "delete_session_resource", %{session_id: session_id, member_id: member_id, resource_ids: img_resource_ids} do
    {:ok, session_resources} = SessionResourcesService.add_session_resources(img_resource_ids, member_id)
    session_resource = List.first(session_resources)
    {:ok, session_resource} = SessionResourcesService.delete(member_id, session_resource.id)

    assert_raise(Ecto.NoResultsError, fn ->
      Repo.get_by!(SessionResource, id: session_resource.id, sessionId: session_id)
    end)
  end

  test "get_sesion_resources", %{session_id: session_id, member_id: member_id, resource_ids: img_resource_ids} do
    {:ok, new_session_resources} = SessionResourcesService.add_session_resources(img_resource_ids, member_id)
    last = List.last(new_session_resources)
    Repo.get_by!(SessionResource, id: last.id, sessionId: session_id)
  end

  test "delete_wrong_member_role_error", %{member2_id: member2_id} do
    assert({:error, "Action not allowed!"} ===
      SessionResourcesService.delete(member2_id, "not important" ))
  end

  test "get_sesion_resources_wrong_member_role_error", %{member2_id: member2_id} do
    assert({:error, "Action not allowed!"} ===
      SessionResourcesService.get_session_resources(member2_id, %{}))
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
end