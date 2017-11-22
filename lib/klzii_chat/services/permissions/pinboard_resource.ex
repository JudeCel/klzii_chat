defmodule KlziiChat.Services.Permissions.PinboardResource do
  import KlziiChat.Services.Permissions.Validations
  import KlziiChat.Services.Permissions.ErrorsHelper, only: [formate_error: 1]
  alias KlziiChat.Helpers.SessionTypeProperty

  @spec can_enable(Map.t, Map.t, Map.t) :: {:ok} | {:error, String.t}
  def can_enable(member, session, %{data: data}) do
    roles = ~w(facilitator accountManager)
    (
      has_role(member, roles) &&
      SessionTypeProperty.get_value(session, ["features", "pinboard", "enabled"]) &&
      has_allowed_from_subscription(data, "pinboardDisplay")
    )
    |> formate_error
  end

  @spec can_display_pinboard(Map.t, Map.t, Map.t) :: {:ok } | {:error, String.t}
  def can_display_pinboard(_, session, %{data: data}) do
    (
      SessionTypeProperty.get_value(session, ["features", "pinboard", "enabled"]) &&
      has_allowed_from_subscription(data, "pinboardDisplay")
    )
    |> formate_error
  end

  @spec can_add_resource(Map.t, Map.t, Map.t) :: {:ok} | {:error, String.t}
  def can_add_resource(member, session, %{data: data}) do
    roles = ~w(participant)
    (
    has_role(member, roles) &&
    SessionTypeProperty.get_value(session, ["features", "pinboard", "enabled"]) &&
    has_allowed_from_subscription(data, "pinboardDisplay")
    )
    |> formate_error
  end

  @spec can_remove_resource(Map.t, Map.t) :: {:ok} | {:error, String.t}
  def can_remove_resource(member, _bject) do
    role = ~w(facilitator accountManager)
    #use this if need owner to remove resource
    #(has_owner(member, object, :sessionMemberId) || has_role(member, role))
    has_role(member, role)
    |> formate_error
  end
end
