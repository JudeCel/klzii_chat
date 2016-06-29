defmodule KlziiChat.Services.Permissions.Console do
  import KlziiChat.Services.Permissions.Validations

  @spec can_set_resource(Map.t) :: Boolean.t
  def can_set_resource(member) do
    roles = ~w(facilitator)
    has_role(member.role, roles)
  end

  @spec can_enable_pinboard(Map.t) :: Boolean.t
  def can_enable_pinboard(member) do
    roles = ~w(facilitator)
    has_role(member.role, roles)
  end

  @spec can_remove_resource(Map.t) :: Boolean.t
  def can_remove_resource(member) do
    roles = ~w(facilitator)
    has_role(member.role, roles)
  end
end
