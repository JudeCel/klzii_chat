defmodule KlziiChat.Services.Permissions.ResourcePermissionsTest do
  use ExUnit.Case, async: true
  alias  KlziiChat.Services.Permissions.Resources

  test "can upload" do
    roles = ["facilitator"]
    Enum.map(roles, fn role ->
      member = %{role: role}
      Resources.can_upload(member)|> assert
    end)
  end

  test "can participant delete only when owner " do
    member = %{id: 1, role: "participant"}
    event = %{id: 1, sessionMemberId: 1}
    Resources.can_delete(member, event) |> assert
  end

  test "can't participant delete when not  owner " do
    member = %{id: 1, role: "participant"}
    event = %{id: 1, sessionMemberId: 2}
    Resources.can_delete(member, event) |> refute
  end

  test "can facilitator delete when he not owner" do
    member = %{id: 1, role: "facilitator"}
    event = %{id: 1, sessionMemberId: 2}
    Resources.can_delete(member, event) |> assert
  end
end
