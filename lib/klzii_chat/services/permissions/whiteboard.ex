defmodule KlziiChat.Services.Permissions.Whiteboard do
  import KlziiChat.Services.Permissions.Validations
  import KlziiChat.Services.Permissions.ErrorsHelper, only: [formate_error: 1]

  @spec can_delete(Map.t, Map.t) :: {:ok } | {:error, String.t}
  def can_delete(member, object) do
    roles = ["facilitator"]
    (has_owner(member, object, :sessionMemberId) || has_role(member.role, roles))
    |> formate_error
  end

  @spec can_new_shape(Map.t, Map.t) :: {:ok } | {:error, String.t}
  def can_new_shape(member, session) do
    session_types_1 = ["focus"]
    roles_1 = ["facilitator", "participant"]
    session_types_2 = ["forum"]
    roles_2 = ["facilitator"]
    ((has_role(member.role, roles_1) && is_in_list(session.type, session_types_1)) || (has_role(member.role, roles_2) && is_in_list(session.type, session_types_2)))
    |> formate_error
  end

  @spec can_add_image(Map.t) :: {:ok } | {:error, String.t}
  def can_add_image(member) do
    roles = ["facilitator"]
    has_role(member.role, roles)
    |> formate_error
  end

  @spec can_edit(Map.t, Map.t) :: {:ok } | {:error, String.t}
  def can_edit(member, object) do
    roles = ["facilitator"]
    (has_owner(member, object, :sessionMemberId) || has_role(member.role, roles))
    |> formate_error
  end
end
