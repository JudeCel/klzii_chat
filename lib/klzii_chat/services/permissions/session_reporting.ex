defmodule KlziiChat.Services.Permissions.SessionReporting do
  import KlziiChat.Services.Permissions.Validations
  import KlziiChat.Services.Permissions.ErrorsHelper, only: [formate_error: 1]
  alias KlziiChat.Services.Permissions.Builder

  @spec can_create_report(Map.t) :: {:ok } | {:error, String.t}
  def can_create_report(session_member) do
    case Builder.session_member_permissions(session_member.id) do
      {:ok, %{reports: %{can_report: can_report}}} ->
        can_report
      _ ->
        false
    end |> formate_error
  end

  @spec can_delete_report(Map.t) :: {:ok } | {:error, String.t}
  def can_delete_report(session_member) do
    case Builder.session_member_permissions(session_member.id) do
      {:ok, %{reports: %{can_report: can_report}}} ->
        can_report
      _ ->
        false
    end |> formate_error
  end

  @spec can_get_reports(Map.t) :: {:ok } | {:error, String.t}
  def can_get_reports(session_member) do
    case Builder.session_member_permissions(session_member.id) do
      {:ok, %{reports: %{can_report: can_report}}} ->
        can_report
      _ ->
        false
    end |> formate_error
  end
end
