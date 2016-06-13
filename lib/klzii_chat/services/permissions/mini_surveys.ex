defmodule KlziiChat.Services.Permissions.MiniSurveys do
  import KlziiChat.Services.Permissions.Validations

  @spec can_delete(Map.t, Map.t) :: Boolean.t
  def can_delete(member, _) do
    roles = ["facilitator"]
    has_role(member.role, roles)
  end

  @spec can_create(Map.t) :: Boolean.t
  def can_create(member) do
    roles = ["facilitator"]
    has_role(member.role, roles)
  end

  @spec can_answer(Map.t) :: Boolean.t
  def can_answer(member) do
    roles = ["facilitator", "participant"]
    has_role(member.role, roles)
  end
end
