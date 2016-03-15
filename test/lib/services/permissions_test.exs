defmodule KlziiChat.Services.PermsionsTest do
  use ExUnit.Case, async: true
  alias  KlziiChat.Services.Permissions

  test "owner can delete" do
    member = %{id: 1, role: "participant"}
    event = %{id: 1, sessionMemberId: 1}
    Permissions.can_delete(member, event) |> assert
  end

  test "facilitator can delete" do
    member = %{id: 1, role: "facilitator"}
    event = %{id: 1, sessionMemberId: 1}
    Permissions.can_delete(member, event) |> assert
  end

  test "other can't delete" do
    member = %{id: 2, role: "participant"}
    event = %{id: 1, sessionMemberId: 1}
    Permissions.can_delete(member, event) |> refute
  end

  test "owner can edit" do
    member = %{id: 1, role: "facilitator"}
    event = %{id: 1, sessionMemberId: 1}
    Permissions.can_edit(member, event) |> assert
  end

  test "other can't edit" do
    member = %{id: 2, role: "facilitator"}
    event = %{id: 1, sessionMemberId: 1}
    Permissions.can_edit(member, event) |> refute
  end

  test "can new message" do
    roles = ["facilitator", "participant"]
    Enum.map(roles, fn role ->
      member = %{role: role}
      Permissions.can_new_message(member)|> assert
    end)
  end

  test "can't new message" do
    roles = ["observer"]
    Enum.map(roles, fn role ->
      member = %{role: role}
      Permissions.can_new_message(member)|> refute
    end)
  end

  test "can vote" do
    roles = ["facilitator", "participant"]
    Enum.map(roles, fn role ->
      member = %{role: role}
      Permissions.can_vote(member)|> assert
    end)
  end

  test "can't vote" do
    roles = ["observer"]
    Enum.map(roles, fn role ->
      member = %{role: role}
      Permissions.can_vote(member)|> refute
    end)
  end

  test "can reply" do
    roles = ["facilitator", "participant"]
    Enum.map(roles, fn role ->
      member = %{role: role}
      Permissions.can_reply(member)|> assert
    end)
  end

  test "can't reply" do
    roles = ["observer"]
    Enum.map(roles, fn role ->
      member = %{role: role}
      Permissions.can_reply(member)|> refute
    end)
  end

  test "can give star" do
    roles = ["facilitator"]
    Enum.map(roles, fn role ->
      member = %{role: role}
      Permissions.can_star(member)|> assert
    end)
  end

  test "can't give star" do
    roles = ["observer", "participant"]
    Enum.map(roles, fn role ->
      member = %{role: role}
      Permissions.can_star(member)|> refute
    end)
  end
end
