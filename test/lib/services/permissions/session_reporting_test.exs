defmodule KlziiChat.Services.Permissions.SessionReportingTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.Permissions.SessionReporting, as: SessionReportingPermissions

  setup %{facilitator: facilitator, participant: participant} do
    {:ok, facilitator: facilitator, participant: participant}
  end

  test "facilitator can create session reports", %{facilitator: facilitator} do
    assert(SessionReportingPermissions.can_create_report(facilitator))
  end

  test "participant can't create session reports", %{participant: participant} do
    refute(SessionReportingPermissions.can_create_report(participant))
  end


  test "facilitator can delete session reports", %{facilitator: facilitator} do
    assert(SessionReportingPermissions.can_delete_report(facilitator))
  end

  test "participant can't delete session reports", %{participant: participant} do
    refute(SessionReportingPermissions.can_delete_report(participant))
  end


  test "facilitator can get session reports", %{facilitator: facilitator} do
    assert(SessionReportingPermissions.can_get_reports(facilitator))
  end

  test "participant can't get session reports", %{participant: participant} do
    refute(SessionReportingPermissions.can_get_reports(participant))
  end

end
