defmodule KlziiChat.Services.Permissions.Whiteboard do
  import KlziiChat.Services.Permissions.Validations
  import KlziiChat.Services.Permissions.ErrorsHelper, only: [formate_error: 1]

  @spec can_display_whiteboard(Map.t, Map.t) :: {:ok } | {:error, String.t}
  def can_display_whiteboard(_member, %{data: data}) do
    ( has_allowed_from_subscription(data, "whiteboardFunctionality"))
    |> formate_error
  end

  @spec can_delete(Map.t, Map.t) :: {:ok } | {:error, String.t}
  def can_delete(member, object) do
    roles = ["facilitator"]
    (has_owner(member, object, :sessionMemberId) || has_role(member.role, roles))
    |> formate_error
  end

  @spec can_new_shape(Map.t, Map.t, Map.t) :: {:ok } | {:error, String.t}
  def can_new_shape(member, session, %{data: data, subscription: subscription}) do
    forum_permissions = %{roles: ["facilitator"], types: ["forum"] }

    focus_permissions = if subscription.planId == "free_trial" do
                          %{roles: ["facilitator"], types: ["focus"] }
                        else
                          %{roles: ["facilitator", "participant"], types: ["focus"] }
                        end
    ((
      (has_role(member.role, forum_permissions.roles) && is_in_list(session.type, forum_permissions.types))
    ||
      (has_role(member.role, focus_permissions.roles) && is_in_list(session.type, focus_permissions.types))
    ) && has_allowed_from_subscription(data, "whiteboardFunctionality"))
    |> formate_error
  end

  @spec can_add_image(Map.t) :: {:ok } | {:error, String.t}
  def can_add_image(member) do
    roles = ["facilitator"]
    has_role(member.role, roles)
    |> formate_error
  end

  @spec can_erase_all(Map.t) :: {:ok } | {:error, String.t}
  def can_erase_all(member) do
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
