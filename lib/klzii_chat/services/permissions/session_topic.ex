defmodule KlziiChat.Services.Permissions.SessionTopic do
  import KlziiChat.Services.Permissions.Validations
  import KlziiChat.Services.Permissions.ErrorsHelper, only: [formate_error: 1]

  @spec can_board_message(Map.t) :: {:ok } | {:error, String.t}
  def can_board_message(member) do
    roles = ["facilitator", "accountManager"]
    has_role(member, roles)
    |> formate_error
  end
end
