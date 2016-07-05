defmodule KlziiChat.Services.Permissions.MessagesTest do
  use ExUnit.Case, async: true
  alias  KlziiChat.Services.Permissions.Messages

  test "owner can delete" do
    member = %{id: 1, role: "participant"}
    event = %{id: 1, sessionMemberId: 1}
    assert( {:ok} = Messages.can_delete(member, event))
  end

  test "facilitator can delete" do
    member = %{id: 1, role: "facilitator"}
    event = %{id: 1, sessionMemberId: 1}
    assert( {:ok} = Messages.can_delete(member, event))
  end

  test "other can't delete" do
    member = %{id: 2, role: "participant"}
    event = %{id: 1, sessionMemberId: 1}
    assert( {:error, _} = Messages.can_delete(member, event))
  end

  test "owner can edit" do
    member = %{id: 1, role: "facilitator"}
    event = %{id: 1, sessionMemberId: 1}
    assert( {:ok} = Messages.can_edit(member, event))
  end

  test "other can't edit" do
    member = %{id: 2, role: "facilitator"}
    event = %{id: 1, sessionMemberId: 1}
    assert( {:error, _} = Messages.can_edit(member, event))
  end

  test "can new message" do
    roles = ["facilitator", "participant"]
    Enum.map(roles, fn role ->
      member = %{role: role}
      assert( {:ok} = Messages.can_new_message(member))
    end)
  end

  test "can't new message" do
    roles = ["observer"]
    Enum.map(roles, fn role ->
      member = %{role: role}
      assert( {:error, _} = Messages.can_new_message(member))
    end)
  end

  test "can vote" do
    roles = ["facilitator", "participant"]
    Enum.map(roles, fn role ->
      member = %{role: role}
      assert( {:ok} = Messages.can_vote(member))
    end)
  end

  test "can't vote" do
    roles = ["observer"]
    Enum.map(roles, fn role ->
      member = %{role: role}
      assert( {:error, _} = Messages.can_vote(member))
    end)
  end

  test "can reply" do
    roles = ["facilitator", "participant"]
    Enum.map(roles, fn role ->
      member = %{role: role}
      assert( {:ok} = Messages.can_reply(member))
    end)
  end

  test "can't reply" do
    roles = ["observer"]
    Enum.map(roles, fn role ->
      member = %{role: role}
      assert( {:error, _} = Messages.can_reply(member))
    end)
  end

  test "can give star" do
    roles = ["facilitator"]
    Enum.map(roles, fn role ->
      member = %{role: role}
      assert( {:ok} = Messages.can_star(member))
    end)
  end

  test "can't give star" do
    roles = ["observer", "participant"]
    Enum.map(roles, fn role ->
      member = %{role: role}
      assert( {:error, _} = Messages.can_star(member))
    end)
  end
end
