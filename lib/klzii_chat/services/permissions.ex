defmodule KlziiChat.Services.Permissions do

  def can_delete(event, member) do
    (has_role(member.role, ["facilitator"]) || has_owner(member, event))
  end

  def can_edit(event, member) do
    (has_role(member.role, ["facilitator"]) || has_owner(member, event))
  end

  def can_vote(member) do
    has_role(member.role, ["facilitator", "participant"])
  end

  def can_reply(member) do
    has_role(member.role, ["facilitator", "participant"])
  end

  def can_star(member) do
    has_role(member.role, ["facilitator"])
  end

  defp has_owner(owner, event) do
    owner.id == event.sessionMemberId
  end

  defp has_role(role, roles) do
    Enum.any?(roles, &(&1 == role))
  end
end
