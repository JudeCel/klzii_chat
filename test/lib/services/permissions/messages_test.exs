defmodule KlziiChat.Services.Permissions.MessagesTest do
  use ExUnit.Case, async: true
  alias  KlziiChat.Services.Permissions.Messages

  test "owner can delete" do
    member = %{id: 1, role: "participant"}
    message = %{id: 1, sessionMemberId: 1}
    assert( {:ok} = Messages.can_delete(member, message))
  end

  test "host can delete" do
    member = %{id: 1, role: "facilitator"}
    message = %{id: 1, sessionMemberId: 1}
    assert( {:ok} = Messages.can_delete(member, message))
  end

  test "other can't delete" do
    member = %{id: 2, role: "participant"}
    message = %{id: 1, sessionMemberId: 1}
    assert( {:error, _} = Messages.can_delete(member, message))
  end

  test "owner can edit" do
    member = %{id: 1, role: "facilitator"}
    message = %{id: 1, sessionMemberId: 1}
    assert( {:ok} = Messages.can_edit(member, message))
  end

  test "other can't edit" do
    member = %{id: 2, role: "facilitator"}
    message = %{id: 1, sessionMemberId: 1}
    assert( {:error, _} = Messages.can_edit(member, message))
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

  test "can vote other messages" do
    roles = ["participant"]
    Enum.map(roles, fn role ->
      message = %{sessionMemberId: 2}
      member = %{id: 1, role: role }
      assert( {:ok} = Messages.can_vote(member, message))
    end)
  end

  test "can't vote own messages" do
    roles = ["participant"]
    Enum.map(roles, fn role ->
      message = %{sessionMemberId: 1}
      member = %{id: 1, role: role}
      assert({:error, _} = Messages.can_vote(member, message))
    end)
  end

  test "can't vote" do
    roles = ["observer", "facilitator"]
    Enum.map(roles, fn role ->
      message = %{}
      member = %{id: 2,role: role}
      assert( {:error, _} = Messages.can_vote(member, message))
    end)
  end

  test "can reply" do
    roles = ["facilitator", "participant"]
    message = %{id: 1, replyId: nil}
    Enum.map(roles, fn role ->
      member = %{role: role}
      assert( {:ok} = Messages.can_reply(member, message))
    end)
  end

  test "can't reply" do
    roles = ["observer"]
    message = %{id: 1, replyId: nil}
    Enum.map(roles, fn role ->
      member = %{role: role}
      assert( {:error, _} = Messages.can_reply(member, message))
    end)
  end

  test "can give star" do
    roles = ["facilitator"]
    Enum.map(roles, fn role ->
      member = %{id: 1, role: role}
      message = %{sessionMemberId: 1}
      assert( {:ok} = Messages.can_star(member, message))
    end)
  end

  test "can't give star" do
    roles = ["observer", "participant", "facilitator"]
    Enum.map(roles, fn role ->
      member = %{id: 1,role: role}
      message = %{sessionMemberId: 1}
      assert( {:error, _} = Messages.can_star(member, message))
    end)
  end
end
