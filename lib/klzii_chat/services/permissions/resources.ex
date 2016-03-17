defmodule KlziiChat.Services.Permissions.Resources do
  import KlziiChat.Services.Permissions.Validations

  @spec can_delete(Map.t, Map.t) :: Boolean.t
  def can_delete(member, object) do
    roles = ["facilitator"]
    has_owner(member, object, :sessionMemberId) || has_role(member.role, roles)
  end

  @spec can_upload(Map.t) :: Boolean.t
  def can_upload(member) do
    roles =  ["facilitator"]
    has_role(member.role, roles)
  end
end
