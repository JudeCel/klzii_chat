defmodule KlziiChat.Services.Permissions.SessionReporting do
  import KlziiChat.Services.Permissions.Validations

  @spec can_create_report(Map.t) :: Boolean.t
  def can_create_report(session_member) do
    roles = ["facilitator"]
    has_role(session_member.role, roles)
  end

  @spec can_delete_report(Map.t) :: Boolean.t
  def can_delete_report(session_member) do
    roles = ["facilitator"]
    has_role(session_member.role, roles)
  end

  @spec can_get_reports(Map.t) :: Boolean.t
  def can_get_reports(session_member) do
    roles = ["facilitator"]
    has_role(session_member.role, roles)
  end
end
