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

  test "can participant delete only when owner " do
    member = %{id: 1, role: "participant"}
    events = [%{id: 1, sessionMemberId: 1}]
    assert( {:ok} = Resources.can_delete(member, events))
  end

  test "can zip when accountManager" do
    member = %{id: 1, role: "accountManager"}
    events = [%{id: 1, accountUser: 1}]
    preference = %{"uploadToGallery" => true}
    assert( {:ok} = Resources.can_zip(member, events, preference))
  end

  test "can zip when admin " do
    member = %{id: 1, role: "admin"}
    events = [%{id: 1, accountUser: 1}]
    assert( {:ok} = Resources.can_zip(member, events))
  end

  test "can't participant delete when not  owner " do
    member = %{id: 1, role: "participant"}
    events = [%{id: 1, sessionMemberId: 2}]
    assert( {:error, _} = Resources.can_delete(member, events))
  end

  test "can facilitator delete when he not owner" do
    member = %{id: 1, role: "facilitator"}
    events = [%{id: 1, sessionMemberId: 2}]
    assert( {:ok} = Resources.can_delete(member, events))
  end

  test "can facilitator delete when he admin" do
    member = %{id: 1, role: "admin"}
    events = [%{id: 1, sessionMemberId: 2}]
    assert( {:ok} = Resources.can_delete(member, events))
  end
end
