defmodule KlziiChat.Services.Permissions.PinboardResource do
  import KlziiChat.Services.Permissions.Validations
  import KlziiChat.Services.Permissions.ErrorsHelper, only: [formate_error: 1]

  @spec error_messages :: Map.t
  def error_messages do
    %{
      action_not_allowed:  "Action not allowed!",
    }
  end

  @spec can_enable(Map.t) :: {:ok} | {:error, String.t}
  def can_enable(member) do
    roles = ~w(facilitator)
    has_role(member.role, roles)
    |> formate_error
  end

  @spec can_add_resource(Map.t) :: {:ok} | {:error, String.t}
  def can_add_resource(member) do
    roles = ~w(participant)
    has_role(member.role, roles)
    |> formate_error
  end

  @spec can_remove_resource(Map.t, Map.t) :: {:ok} | {:error, String.t}
  def can_remove_resource(member, object) do
    role = ~w(facilitator)
    (has_owner(member, object, :sessionMemberId) || has_role(member.role, role))
    |> formate_error
  end
end
