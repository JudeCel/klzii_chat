defmodule KlziiChat.Services.Permissions.ReportTest do
  use ExUnit.Case, async: true
  alias KlziiChat.Services.Permissions.Report, as: ReportPermissions

    describe "host" do
      test "can use when preference" do
        preference = %{data: %{"reportingFunctions" => true}}
        member = %{id: 1, role: "facilitator", account_user: %{role: "accountManager"}}
        assert( {:ok} = ReportPermissions.can_use(member, preference))
      end

      test "can't use whitout preference" do
        preference = %{data: %{"reportingFunctions" => false}}
        member = %{id: 1, role: "facilitator", account_user: %{role: "accountManager"}}
        assert( {:error, _} = ReportPermissions.can_use(member, preference))
      end
    end

    describe "guest" do
      test "can use" do
        preference = %{data: %{"reportingFunctions" => true}}
        member = %{id: 1, role: "participant", account_user: %{role: "guest"}}
        assert( {:error, _} = ReportPermissions.can_use(member, preference))
      end
    end

    describe "spectator" do
      test "can't use" do
        preference = %{data: %{"reportingFunctions" => true}}
        member = %{id: 1, role: "observer", account_user: %{role: "spectator"}}
        assert( {:error, _} = ReportPermissions.can_use(member, preference))
      end

      test "can use" do
        preference = %{data: %{"reportingFunctions" => true}}
        member = %{id: 1, role: "observer", account_user: %{role: "accountManager"}}
        assert( {:ok} = ReportPermissions.can_use(member, preference))
      end
    end
end
