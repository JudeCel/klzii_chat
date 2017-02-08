defmodule KlziiChat.Services.Permissions.Whiteboard do
  import KlziiChat.Services.Permissions.Validations
  import KlziiChat.Services.Permissions.ErrorsHelper, only: [formate_error: 1]

  @spec can_display_whiteboard(Map.t, Map.t) :: {:ok } | {:error, String.t}
  def can_display_whiteboard(_member, %{data: data}) do
    ( has_allowed_from_subscription(data, "whiteboardDisplay"))
    |> formate_error
  end

  @spec can_delete(Map.t, Map.t) :: {:ok } | {:error, String.t}
  def can_delete(member, object) do
    roles = ["facilitator"]
    (has_owner(member, object, :sessionMemberId) || has_role(member.role, roles))
    |> formate_error
  end

  defp validate_subscription(member, preference) do
    sub_key = case member do
                %{role: "facilitator"} ->
                  "whiteboardDisplay"
                _ ->
                  "whiteboardFunctionality"
              end
    has_allowed_from_subscription(preference, sub_key)
  end

  defp validate_session(member, session) do
    roles = case session do
              %{type: "forum"} ->
                ["facilitator"]
              %{type: "focus"} ->
                ["facilitator", "participant"]
              _ ->
                []
            end
    has_role(member.role, roles)
  end

  @spec can_new_shape(Map.t, Map.t, Map.t) :: {:ok } | {:error, String.t}
  def can_new_shape(member, session, %{data: data}) do
    with(
      true <- validate_subscription(member, data),
      true <- validate_session(member, session)
    ) do
        formate_error(true)
      else
        _ ->
          formate_error(false)
      end
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
