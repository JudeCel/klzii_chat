defmodule KlziiChat.Services.Permissions.Whiteboard do
  import KlziiChat.Services.Permissions.Validations
  import KlziiChat.Services.Permissions.ErrorsHelper, only: [formate_error: 1]
  alias KlziiChat.Helpers.SessionTypeProperty

  @spec can_display_whiteboard(Map.t) :: {:ok } | {:error, String.t}
  def can_display_whiteboard(%{data: data}) do
    (has_allowed_from_subscription(data, "whiteboardDisplay"))
    |> formate_error
  end

  @spec can_enable(Map.t, Map.t, Map.t) :: {:ok } | {:error, String.t}
  def can_enable(member, session, %{data: data}) do
    roles = ~w(facilitator accountManager)
    (
      has_role(member, roles) &&
      SessionTypeProperty.get_value(session, ["features", "whiteboard", "enabled"]) &&
      has_allowed_from_subscription(data, "whiteboardDisplay")
    )
    |> formate_error
  end

  @spec can_delete(Map.t, Map.t) :: {:ok } | {:error, String.t}
  def can_delete(member, object) do
    roles = ["facilitator", "accountManager"]
    (has_owner(member, object, :sessionMemberId) || has_role(member, roles))
    |> formate_error
  end

  defp validate_subscription(member, preference) do
    roles = ["facilitator", "accountManager"]
    sub_key = case has_role(member, roles) do
      true -> "whiteboardDisplay"
      _ -> "whiteboardFunctionality"
    end
    has_allowed_from_subscription(preference, sub_key)
  end

  defp validate_session(member, session) do
    whiteboard_properties = SessionTypeProperty.get_value(session, ["features", "whiteboard"])
    roles = case whiteboard_properties["enabled"] do
      true ->
        whiteboard_properties["canWrite"]
      _ ->
        []
    end
    has_role(member, roles)
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
    roles = ["facilitator", "accountManager"]
    has_role(member, roles)
    |> formate_error
  end

  @spec can_erase_all(Map.t) :: {:ok } | {:error, String.t}
  def can_erase_all(member) do
    roles = ["facilitator", "accountManager"]
    has_role(member, roles)
    |> formate_error
  end

  @spec can_edit(Map.t, Map.t) :: {:ok } | {:error, String.t}
  def can_edit(member, object) do
    roles = ["facilitator", "accountManager"]
    (has_owner(member, object, :sessionMemberId) || has_role(member, roles))
    |> formate_error
  end
end
