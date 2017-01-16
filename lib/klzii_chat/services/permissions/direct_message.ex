defmodule KlziiChat.Services.Permissions.DirectMessage do
  import KlziiChat.Services.Permissions.Validations
  import KlziiChat.Services.Permissions.ErrorsHelper, only: [formate_error: 1]

  @spec can_write(Map.t, Map.t) :: {:ok } | {:error, String.t}
  def can_write(current_member, other_member) do
    participant = ["participant"]
    observer = ["observer"]
    facilitator = ["facilitator"]

    current_member.id != other_member.id && (
      has_role(current_member.role, participant) && has_role(other_member.role, facilitator) ||
      has_role(current_member.role, facilitator) && has_role(other_member.role, participant) ||
      has_role(current_member.role, observer) && has_role(other_member.role, facilitator) ||
      has_role(current_member.role, facilitator) && has_role(other_member.role, observer)
    ) |> formate_error
  end

  @spec can_direct_message(Map.t) :: {:ok } | {:error, String.t}
  def can_direct_message(member) do
    roles = ["facilitator", "participant", "observer"]
    has_role(member.role, roles)
    |> formate_error
  end
end
