defmodule KlziiChat.Services.Permissions.Whiteboard do
  import KlziiChat.Services.Permissions.Validations
  import KlziiChat.Services.Permissions.ErrorsHelper, only: [formate_error: 1]

  @spec can_delete(Map.t, Map.t) :: {:ok } | {:error, String.t}
  def can_delete(member, object) do
    roles = ["facilitator"]
    (has_owner(member, object, :sessionMemberId) || has_role(member.role, roles))
    |> formate_error
  end

  @spec can_new_shape(Map.t) :: {:ok } | {:error, String.t}
  def can_new_shape(member) do
    roles = ["facilitator", "participant"]
    has_role(member.role, roles)
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
