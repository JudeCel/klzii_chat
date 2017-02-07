defmodule KlziiChat.Services.Permissions.PinboardResource do
  import KlziiChat.Services.Permissions.Validations
  import KlziiChat.Services.Permissions.ErrorsHelper, only: [formate_error: 1]

  @spec can_enable(Map.t, Map.t) :: {:ok} | {:error, String.t}
  def can_enable(member, session) do
    roles = ~w(facilitator)
    session_types = ~w(focus)
    (has_role(member.role, roles) && is_in_list(session.type, session_types))
    |> formate_error
  end

  @spec can_display_pinboard(Map.t, Map.t) :: {:ok } | {:error, String.t}
  def can_display_pinboard(_, %{data: data}) do
    (has_allowed_from_subscription(data, "pinboardDisplay"))
    |> formate_error
  end

  @spec can_add_resource(Map.t, Map.t) :: {:ok} | {:error, String.t}
  def can_add_resource(member, session) do
    roles = ~w(participant)
    session_types = ~w(focus)
    (has_role(member.role, roles) && is_in_list(session.type, session_types))
    |> formate_error
  end

  @spec can_remove_resource(Map.t, Map.t) :: {:ok} | {:error, String.t}
  def can_remove_resource(member, object) do
    role = ~w(facilitator)
    #use this if need owner to remove resource
    #(has_owner(member, object, :sessionMemberId) || has_role(member.role, role))
    has_role(member.role, role)
    |> formate_error
  end
end
