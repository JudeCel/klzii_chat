defmodule KlziiChat.Services.Permissions.ResourcePermissionsTest do
  use ExUnit.Case, async: true
  alias  KlziiChat.Services.Permissions.Resources

  test "can upload" do
    preference = %{"uploadToGallery" =>  true}
    roles = ["facilitator"]
    Enum.map(roles, fn role ->
      member = %{role: role}
      assert( {:ok} = Resources.can_upload(member, preference))
    end)
  end

  test "can guest delete only when owner " do
    member = %{id: 1, role: "participant"}
    events = [%{id: 1, sessionMemberId: 1}]
    assert( {:ok} = Resources.can_delete(member, events))
  end

  test "can't guest delete when not  owner " do
    member = %{id: 1, role: "participant"}
    events = [%{id: 1, sessionMemberId: 2}]
    assert( {:error, _} = Resources.can_delete(member, events))
  end

  test "can host delete when he not owner" do
    member = %{id: 1, role: "facilitator"}
    events = [%{id: 1, sessionMemberId: 2}]
    assert( {:ok} = Resources.can_delete(member, events))
  end

  test "can host delete when he admin" do
    member = %{id: 1, role: "admin"}
    events = [%{id: 1, sessionMemberId: 2}]
    assert( {:ok} = Resources.can_delete(member, events))
  end

  test "host only can see resource section" do
    member = %{id: 1, role: "facilitator"}
    assert( {:ok} = Resources.can_see_section(member))
  end
end
