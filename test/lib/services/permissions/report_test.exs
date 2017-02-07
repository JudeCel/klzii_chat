defmodule KlziiChat.Services.Permissions.ReportTest do
  use ExUnit.Case, async: true
  alias KlziiChat.Services.Permissions.Report, as: ReportPermissions

    describe "host" do
      test "can use when preference" do
        preference = %{data: %{"reportingFunctions" => true}}
        member = %{id: 1, role: "facilitator"}
        assert( {:ok} = ReportPermissions.can_use(member, preference))
      end

      test "can't use whitout preference" do
        preference = %{data: %{"reportingFunctions" => false}}
        member = %{id: 1, role: "facilitator"}
        assert( {:error, _} = ReportPermissions.can_use(member, preference))
      end
    end

    describe "guest" do
      test "can use" do
        preference = %{data: %{"reportingFunctions" => true}}
        member = %{id: 1, role: "participant"}
        assert( {:error, _} = ReportPermissions.can_use(member, preference))
      end
    end

    describe "spectator" do
      test "can use" do
        preference = %{data: %{"reportingFunctions" => true}}
        member = %{id: 1, role: "observer"}
        assert( {:error, _} = ReportPermissions.can_use(member, preference))
      end
    end
end
