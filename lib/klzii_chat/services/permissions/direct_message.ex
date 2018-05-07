defmodule KlziiChat.Services.Permissions.DirectMessage do
  import KlziiChat.Services.Permissions.Validations
  import KlziiChat.Services.Permissions.ErrorsHelper, only: [formate_error: 1]

  @spec can_write(Map.t, Map.t) :: {:ok } | {:error, String.t}
  def can_write(current_member, other_member) do
    participant = ["participant"]
    observer = ["observer"]
    facilitator = ["facilitator", "accountManager", "admin"]

    current_member.id != other_member.id && (
      has_role(current_member, participant) && has_role(other_member, facilitator) ||
      has_role(current_member, facilitator) && has_role(other_member, participant) ||
      has_role(current_member, observer) && has_role(other_member, facilitator) ||
      has_role(current_member, facilitator) && has_role(other_member, observer)
    ) |> formate_error
  end

  @spec can_direct_message(Map.t) :: {:ok } | {:error, String.t}
  def can_direct_message(member) do
    roles = ["facilitator", "participant", "observer"]
    has_role(member, roles)
    |> formate_error
  end
end
