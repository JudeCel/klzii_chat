defmodule KlziiChat.Services.Permissions.DirectMessage do
  import KlziiChat.Services.Permissions.Validations

  @spec can_write(Map.t, Map.t) :: Boolean.t
  def can_write(current_member, other_member) do
    participant = ["participant"]
    facilitator = ["facilitator"]

    current_member.id != other_member.id && (
      has_role(current_member.role, participant) && has_role(other_member.role, facilitator) ||
      has_role(current_member.role, facilitator) && has_role(other_member.role, participant)
    )
  end
end
