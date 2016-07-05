defmodule KlziiChat.Services.Permissions.SessionTopic do
  import KlziiChat.Services.Permissions.Validations
  import KlziiChat.Services.Permissions.ErrorsHelper, only: [formate_error: 1]

  @spec can_board_message(Map.t) :: Boolean.t
  def can_board_message(member) do
    roles = ["facilitator"]
    has_role(member.role, roles)
    |> formate_error
  end
end
