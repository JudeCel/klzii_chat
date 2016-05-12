defmodule KlziiChat.Services.Permissions.SessionResources do
  import KlziiChat.Services.Permissions.Validations

  @spec can_add_resources(Map.t) :: Boolean.t
  def can_add_resources(member) do
    roles = ["facilitator"]
    has_role(member.role, roles)
  end

  @spec can_remove_resource(Map.t) :: Boolean.t
  def can_remove_resource(member) do
    roles = ["facilitator"]
    has_role(member.role, roles)
  end

  @spec can_get_resources(Map.t) :: Boolean.t
  def can_get_resources(member) do
    roles = ["facilitator"]
    has_role(member.role, roles)
  end
end
