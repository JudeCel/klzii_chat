defmodule KlziiChat.Services.Permissions.Member do
  import KlziiChat.Services.Permissions.Validations
  import KlziiChat.Services.Permissions.ErrorsHelper, only: [formate_error: 1]

  @spec can_change_name(Map.t, Map.t) :: {:ok } | {:error, String.t}
  def can_change_name(member, %{anonymous: true}) do
    roles = ["facilitator", "accountManager"]
    has_role(member, roles)
    |> formate_error
  end
  def can_change_name(member, _) do
    roles = ["facilitator", "accountManager", "participant"]
    has_role(member, roles)
    |> formate_error
  end
end
