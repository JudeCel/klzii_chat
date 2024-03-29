defmodule KlziiChat.Services.Permissions.SessionTopic do
  import KlziiChat.Services.Permissions.Validations
  import KlziiChat.Services.Permissions.ErrorsHelper, only: [formate_error: 1]

  @spec can_board_message(Map.t) :: {:ok } | {:error, String.t}
  def can_board_message(member) do
    roles = ["facilitator", "accountManager", "admin"]
    has_role(member, roles)
    |> formate_error
  end

  @spec can_change_active(Map.t) :: {:ok } | {:error, String.t}
  def can_change_active(member) do
    roles = ["facilitator", "accountManager", "admin"]
    has_role(member, roles)
    |> formate_error
  end
end
