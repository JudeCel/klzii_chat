defmodule KlziiChat.Services.Permissions.SessionReportingTest do
  use ExUnit.Case, async: true
  alias KlziiChat.Services.Permissions.SessionReporting, as: SessionReportingPermissions

  test "facilitator can create session reports" do
    facilitator = %{id: 1, role: "facilitator"}
    assert(SessionReportingPermissions.can_create_report(facilitator))
  end

  test "participant can't create session reports" do
    participant = %{id: 2, role: "participant"}
    refute(SessionReportingPermissions.can_create_report(participant))
  end


  test "facilitator can delete session reports" do
    facilitator = %{id: 1, role: "facilitator"}
    assert(SessionReportingPermissions.can_delete_report(facilitator))
  end

  test "participant can't delete session reports" do
    participant = %{id: 2, role: "participant"}
    refute(SessionReportingPermissions.can_delete_report(participant))
  end


  test "facilitator can get session reports" do
    facilitator = %{id: 1, role: "facilitator"}
    assert(SessionReportingPermissions.can_get_reports(facilitator))
  end

  test "participant can't get session reports" do
    participant = %{id: 2, role: "participant"}
    refute(SessionReportingPermissions.can_get_reports(participant))
  end

end
