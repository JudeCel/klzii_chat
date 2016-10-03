defmodule KlziiChat.Services.Permissions.SessionResources do
  import KlziiChat.Services.Permissions.Validations
  import KlziiChat.Services.Permissions.ErrorsHelper, only: [formate_error: 1]

  @spec can_add_resources(Map.t) :: {:ok } | {:error, String.t}
  def can_add_resources(member) do
    roles = ["facilitator"]
    has_role(member.role, roles)
    |> formate_error
  end

  @spec can_remove_resource(Map.t) :: {:ok } | {:error, String.t}
  def can_remove_resource(member) do
    roles = ["facilitator"]
    has_role(member.role, roles)
    |> formate_error
  end

  @spec can_get_resources(Map.t) :: {:ok } | {:error, String.t}
  def can_get_resources(member) do
    roles = ["facilitator"]
    has_role(member.role, roles)
    |> formate_error
  end
end
