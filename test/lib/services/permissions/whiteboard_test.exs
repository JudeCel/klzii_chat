defmodule KlziiChat.Services.Permissions.WhiteboardTest do
  use ExUnit.Case, async: true
  alias  KlziiChat.Services.Permissions.Whiteboard

  test "#Permissions.Whiteboard facilitator can delete shape" do
    member = %{id: 1, role: "facilitator"}
    shape = %{id: 1, sessionMemberId: 2}
    assert({:ok} = Whiteboard.can_delete(member, shape))
  end

  test "#Permissions.Whiteboard facilitator can add image" do
    member = %{id: 1, role: "facilitator"}
    assert({:ok} = Whiteboard.can_add_image(member))
  end
  test "#Permissions.Whiteboard participent or observer can't add image" do
    roles = ["observer", "participant"]
    Enum.map(roles, fn role ->
      member = %{role: role}
      assert({:error, _} = Whiteboard.can_add_image(member))
    end)
  end

  test "#Permissions.Whiteboard owner can delete shape" do
    member = %{id: 1, role: "participant"}
    shape = %{id: 1, sessionMemberId: 1}
    assert({:ok} = Whiteboard.can_delete(member, shape))
  end

  test "#Permissions.Whiteboard owner can edit shape" do
    member = %{id: 1, role: "facilitator"}
    shape = %{id: 1, sessionMemberId: 1}
    assert({:ok} = Whiteboard.can_edit(member, shape))
  end

  test "#Permissions.Whiteboard facilitator can edit shape" do
    member = %{id: 2, role: "facilitator"}
    shape = %{id: 1, sessionMemberId: 1}
    assert({:ok} = Whiteboard.can_edit(member, shape))
  end

  test "#Permissions.Whiteboard can new shape when session type is focus" do
    roles = ["facilitator", "participant"]
    session = %{type: "focus"}
    Enum.map(roles, fn role ->
      member = %{role: role}
      assert({:ok} = Whiteboard.can_new_shape(member, session))
    end)
  end

  test "#Permissions.Whiteboard can new shape when session type is forum" do
    roles = ["facilitator"]
    session = %{type: "forum"}
    Enum.map(roles, fn role ->
      member = %{role: role}
      assert({:ok} = Whiteboard.can_new_shape(member, session))
    end)
  end

  test "#Permissions.Whiteboard can't new shape when session type is forum" do
    roles = ["participant"]
    session = %{type: "forum"}
    Enum.map(roles, fn role ->
      member = %{role: role}
      assert({:error, _} = Whiteboard.can_new_shape(member, session))
    end)
  end

  test "#Permissions.Whiteboard can't new shape" do
    sessions = ["forum", "focus"]
    roles = ["observer"]
    Enum.map(roles, fn role ->
      member = %{role: role}
      Enum.map(sessions, fn type ->
        session = %{type: type}
        assert({:error, _} = Whiteboard.can_new_shape(member, session))
      end)
    end)
  end
end
