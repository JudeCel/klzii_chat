defmodule KlziiChat.Services.Permissions.Console do
  import KlziiChat.Services.Permissions.Validations

  @spec error_messages :: Map.t
  def error_messages do
    %{
      action_not_allowed:  "Action not allowed!"
    }
  end

  @spec can_set_resource(Map.t) :: Boolean.t
  def can_set_resource(member) do
    roles = ~w(facilitator)
    has_role(member.role, roles)
    |> add_response
  end

  @spec can_remove_resource(Map.t) :: Boolean.t
  def can_remove_resource(member) do
    roles = ~w(facilitator)
    has_role(member.role, roles)
    |> add_response
  end

  defp add_response(true) do
    {:ok}
  end

  defp add_response(false) do
    {:error, %{permissions: error_messages.action_not_allowed}}
  end
end
