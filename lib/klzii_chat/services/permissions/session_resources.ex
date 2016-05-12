defmodule KlziiChat.Services.Permissions.SessionResources do
  import KlziiChat.Services.Permissions.Validations

  @spec can_toggle_resources(Map.t) :: Boolean.t
  def can_toggle_resources(member) do
    roles = ["facilitator"]
    has_role(member.role, roles)
  end
end
