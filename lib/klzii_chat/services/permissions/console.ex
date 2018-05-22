defmodule KlziiChat.Services.Permissions.Console do
  import KlziiChat.Services.Permissions.Validations
  import KlziiChat.Services.Permissions.ErrorsHelper, only: [formate_error: 1]

  @spec can_set_resource(Map.t) :: {:ok } | {:error, String.t}
  def can_set_resource(member) do
    roles = ~w(facilitator accountManager admin)
    has_role(member, roles)
    |> formate_error
  end

  @spec can_enable_pinboard(Map.t) :: {:ok } | {:error, String.t}
  def can_enable_pinboard(member) do
    roles = ~w(facilitator accountManager admin)
    (has_role(member, roles))
    |> formate_error
  end

  @spec can_remove_resource(Map.t) :: {:ok} | {:error, String.t}
  def can_remove_resource(member) do
    roles = ~w(facilitator accountManager admin)
    has_role(member, roles)
    |> formate_error
  end
end
