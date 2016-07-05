defmodule KlziiChat.Services.Permissions.Console do
  import KlziiChat.Services.Permissions.Validations
  import KlziiChat.Services.Permissions.ErrorsHelper, only: [formate_error: 1]

  @spec can_set_resource(Map.t) :: Boolean.t
  def can_set_resource(member) do
    roles = ~w(facilitator)
    has_role(member.role, roles)
    |> formate_error
  end

  @spec can_remove_resource(Map.t) :: Boolean.t
  def can_remove_resource(member) do
    roles = ~w(facilitator)
    has_role(member.role, roles)
    |> formate_error
  end
end
