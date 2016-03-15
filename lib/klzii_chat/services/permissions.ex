defmodule KlziiChat.Services.Permissions do

  @spec can_delete(Map.t, Map.t) :: Boolean.t
  def can_delete(member, event) do
    has_owner(member, event) || has_role(member.role, ["facilitator"])
  end

  @spec can_new_message(Map.t) :: Boolean.t
  def can_new_message(member) do
    has_role(member.role, ["facilitator", "participant"])
  end

  @spec can_edit(Map.t, Map.t) :: Boolean.t
  def can_edit(member, event) do
     has_owner(member, event)
  end

  @spec can_vote(Map.t) :: Boolean.t
  def can_vote(member) do
    has_role(member.role, ["facilitator", "participant"])
  end

  @spec can_reply(Map.t) :: Boolean.t
  def can_reply(member) do
    has_role(member.role, ["facilitator", "participant"])
  end

  @spec can_star(Map.t) :: Boolean.t
  def can_star(member) do
    has_role(member.role, ["facilitator"])
  end

  @spec has_owner(Map.t, Map.t) :: Boolean.t
  defp has_owner(member, event) do
    member.id == event.sessionMemberId
  end

  @spec has_role(String.t, List.t) :: Boolean.t
  defp has_role(role, roles) do
    Enum.any?(roles, &(&1 == role))
  end
end
