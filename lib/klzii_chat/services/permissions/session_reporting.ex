defmodule KlziiChat.Services.Permissions.SessionReporting do
  import KlziiChat.Services.Permissions.Validations
  alias KlziiChat.Services.Permissions.Builder

  @spec can_create_report(Map.t) :: Boolean.t
  def can_create_report(session_member) do
    roles = ["facilitator"]
    {:ok, %{reports: %{can_report: can_report}}} = Builder.session_member_permissions(session_member.id)
    has_role(session_member.role, roles) && can_report
  end

  @spec can_delete_report(Map.t) :: Boolean.t
  def can_delete_report(session_member) do
    roles = ["facilitator"]
    {:ok, %{reports: %{can_report: can_report}}} = Builder.session_member_permissions(session_member.id)
    has_role(session_member.role, roles) && can_report
  end

  @spec can_get_reports(Map.t) :: Boolean.t
  def can_get_reports(session_member) do
    roles = ["facilitator"]
    {:ok, %{reports: %{can_report: can_report}}} = Builder.session_member_permissions(session_member.id)
    has_role(session_member.role, roles) && can_report
  end
end
