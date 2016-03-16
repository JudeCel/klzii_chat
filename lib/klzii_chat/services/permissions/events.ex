defmodule KlziiChat.Services.Permissions.Events do
  import KlziiChat.Services.Permissions.Validations

  @spec can_delete(Map.t, Map.t) :: Boolean.t
  def can_delete(member, object) do
    roles = ["facilitator"]
    has_owner(member, object, :sessionMemberId) || has_role(member.role, roles)
  end

  @spec can_new_message(Map.t) :: Boolean.t
  def can_new_message(member) do
    roles = ["facilitator", "participant"]
    has_role(member.role, roles)
  end

  @spec can_edit(Map.t, Map.t) :: Boolean.t
  def can_edit(member, object) do
     has_owner(member, object, :sessionMemberId)
  end

  @spec can_vote(Map.t) :: Boolean.t
  def can_vote(member) do
    roles = ["facilitator", "participant"]
    has_role(member.role, roles)
  end

  @spec can_reply(Map.t) :: Boolean.t
  def can_reply(member) do
    roles = ["facilitator", "participant"]
    has_role(member.role, roles)
  end

  @spec can_star(Map.t) :: Boolean.t
  def can_star(member) do
    roles = ["facilitator"]
    has_role(member.role, roles)
  end

end
