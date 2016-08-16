defmodule KlziiChat.Services.Permissions.SessionTest do
  use ExUnit.Case, async: true
  alias KlziiChat.Services.Permissions.Session, as: SessionPermissions
  alias KlziiChat.{Session, SessionMember, AccountUser}


  describe "Account Manager" do
    setup do
      {:ok, account_user: %AccountUser{role: "accountManager"}}
    end

    test "Session member role facilitator", %{account_user: account_user} do
      member = %SessionMember{role: "facilitator"}
      assert({:ok} = SessionPermissions.can_access?(account_user, member, %Session{status: "open"}))
      assert({:ok} = SessionPermissions.can_access?(account_user, member, %Session{status: "close"}))
      assert({:ok} = SessionPermissions.can_access?(account_user, member, %Session{status: "expired"}))
      assert({:ok} = SessionPermissions.can_access?(account_user, member, %Session{status: "pending"}))
    end

    test "Session member role participant", %{account_user: account_user} do
      member = %SessionMember{role: "participant"}
      assert({:ok} = SessionPermissions.can_access?(account_user, member, %Session{status: "open"}))
      assert({:ok} = SessionPermissions.can_access?(account_user, member, %Session{status: "close"}))
      assert({:ok} = SessionPermissions.can_access?(account_user, member, %Session{status: "expired"}))
      assert({:ok} = SessionPermissions.can_access?(account_user, member, %Session{status: "pending"}))
    end

    test "Session member role observer", %{account_user: account_user} do
      member = %SessionMember{role: "observer"}
      assert({:ok} = SessionPermissions.can_access?(account_user, member, %Session{status: "open"}))
      assert({:ok} = SessionPermissions.can_access?(account_user, member, %Session{status: "close"}))
      assert({:error, _} = SessionPermissions.can_access?(account_user, member, %Session{status: "expired"}))
      assert({:error, _} = SessionPermissions.can_access?(account_user, member, %Session{status: "pending"}))
    end
  end

  describe "No Account Manager and facilitator" do
    setup do
      {:ok, account_user: %AccountUser{role: "facilitator"}}
    end

    test "Session member role facilitator", %{account_user: account_user} do
      member = %SessionMember{role: "facilitator"}
      assert({:ok} = SessionPermissions.can_access?(account_user, member, %Session{status: "open"}))
      assert({:ok} = SessionPermissions.can_access?(account_user, member, %Session{status: "close"}))
      assert({:ok} = SessionPermissions.can_access?(account_user, member, %Session{status: "expired"}))
      assert({:ok} = SessionPermissions.can_access?(account_user, member, %Session{status: "pending"}))
  end

    test "Session member role participant", %{account_user: account_user} do
      member = %SessionMember{role: "participant"}
      assert({:ok} = SessionPermissions.can_access?(account_user, member, %Session{status: "open"}))
      assert({:error, _} = SessionPermissions.can_access?(account_user, member, %Session{status: "close"}))
      assert({:error, _} = SessionPermissions.can_access?(account_user, member, %Session{status: "expired"}))
      assert({:error, _} = SessionPermissions.can_access?(account_user, member, %Session{status: "pending"}))
    end

    test "Session member role observer", %{account_user: account_user} do
      member = %SessionMember{role: "observer"}
      assert({:ok} = SessionPermissions.can_access?(account_user, member, %Session{status: "open"}))
      assert({:ok} = SessionPermissions.can_access?(account_user, member, %Session{status: "close"}))
      assert({:error, _} = SessionPermissions.can_access?(account_user, member, %Session{status: "expired"}))
      assert({:error, _} = SessionPermissions.can_access?(account_user, member, %Session{status: "pending"}))
    end
  end
end
