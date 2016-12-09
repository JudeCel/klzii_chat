defmodule KlziiChat.Services.Permissions.SessionReportingTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.Permissions.SessionReporting, as: SessionReportingPermissions

  describe "host" do
    test "can create session reports", %{facilitator: facilitator} do
      assert({:ok} = SessionReportingPermissions.can_create_report(facilitator))
    end

    test "can delete session reports", %{facilitator: facilitator} do
      assert({:ok} = SessionReportingPermissions.can_delete_report(facilitator))
    end

    test "can get session reports", %{facilitator: facilitator} do
      assert({:ok} = SessionReportingPermissions.can_get_reports(facilitator))
    end
  end

  describe "guest" do
    test "can't create session reports", %{participant: participant} do
      assert({:error, _} = SessionReportingPermissions.can_create_report(participant))
    end

    test "can't delete session reports", %{participant: participant} do
      assert({:error, _} = SessionReportingPermissions.can_delete_report(participant))
    end

    test "can't get session reports", %{participant: participant} do
      assert({:error, _} = SessionReportingPermissions.can_get_reports(participant))
    end
  end

  describe "spectator" do
    test "can't create session reports", %{observer: observer} do
      assert({:error, _} = SessionReportingPermissions.can_create_report(observer))
    end

    test "can't delete session reports", %{observer: observer} do
      assert({:error, _} = SessionReportingPermissions.can_delete_report(observer))
    end

    test "can't get session reports", %{observer: observer} do
      assert({:error, _} = SessionReportingPermissions.can_get_reports(observer))
    end
  end
end
