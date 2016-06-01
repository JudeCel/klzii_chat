defmodule KlziiChat.Services.Permissions.WhiteboardTest do
  use ExUnit.Case, async: true
  alias  KlziiChat.Services.Permissions.Whiteboard

  test "#Permissions.Whiteboard facilitator can delete shape" do
    member = %{id: 1, role: "facilitator"}
    shape = %{id: 1, sessionMemberId: 2}
    Whiteboard.can_delete(member, shape) |> assert
  end

  test "#Permissions.Whiteboard owner can delete shape" do
    member = %{id: 1, role: "participant"}
    shape = %{id: 1, sessionMemberId: 1}
    Whiteboard.can_delete(member, shape) |> assert
  end

  test "#Permissions.Whiteboard owner can edit shape" do
    member = %{id: 1, role: "facilitator"}
    shape = %{id: 1, sessionMemberId: 1}
    Whiteboard.can_edit(member, shape) |> assert
  end

  test "#Permissions.Whiteboard facilitator can edit shape" do
    member = %{id: 2, role: "facilitator"}
    shape = %{id: 1, sessionMemberId: 1}
    Whiteboard.can_edit(member, shape) |> assert
  end

  test "#Permissions.Whiteboard can new shape" do
    roles = ["facilitator", "participant"]
    Enum.map(roles, fn role ->
      member = %{role: role}
      Whiteboard.can_new_shape(member)|> assert
    end)
  end

  test "#Permissions.Whiteboard can't new shape" do
    roles = ["observer"]
    Enum.map(roles, fn role ->
      member = %{role: role}
      Whiteboard.can_new_shape(member)|> refute
    end)
  end
end
