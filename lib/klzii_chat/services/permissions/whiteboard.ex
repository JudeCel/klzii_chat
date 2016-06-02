defmodule KlziiChat.Services.Permissions.Whiteboard do
  import KlziiChat.Services.Permissions.Validations

  @spec can_delete(Map.t, Map.t) :: Boolean.t
  def can_delete(member, object) do
    roles = ["facilitator"]
    has_owner(member, object, :sessionMemberId) || has_role(member.role, roles)
  end

  @spec can_new_shape(Map.t) :: Boolean.t
  def can_new_shape(member) do
    roles = ["facilitator", "participant"]
    has_role(member.role, roles)
  end

  @spec can_edit(Map.t, Map.t) :: Boolean.t
  def can_edit(member, object) do
    roles = ["facilitator"]
    has_owner(member, object, :sessionMemberId) || has_role(member.role, roles)
  end
end
