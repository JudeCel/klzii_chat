defmodule KlziiChat.Authorisations.Controller.SessionTest do
  use ExUnit.Case, async: true
  alias KlziiChat.Authorisations.Controller.Session, as: AuthorisationSession
  alias KlziiChat.{Session, SessionMember, AccountUser}


  describe "Account Manager" do
    setup do
      {:ok, account_user: %AccountUser{role: "accountManager"}}
    end

    test "Session member role faciltitator", %{account_user: account_user} do
      member = %SessionMember{role: "faciltitator"}
      assert({:ok} = AuthorisationSession.authorized?(account_user, member, %Session{status: "open"}))
      assert({:ok} = AuthorisationSession.authorized?(account_user, member, %Session{status: "close"}))
      assert({:ok} = AuthorisationSession.authorized?(account_user, member, %Session{status: "expired"}))
      assert({:ok} = AuthorisationSession.authorized?(account_user, member, %Session{status: "pending"}))
    end

    test "Session member role participant", %{account_user: account_user} do
      member = %SessionMember{role: "participant"}
      assert({:ok} = AuthorisationSession.authorized?(account_user, member, %Session{status: "open"}))
      assert({:ok} = AuthorisationSession.authorized?(account_user, member, %Session{status: "close"}))
      assert({:ok} = AuthorisationSession.authorized?(account_user, member, %Session{status: "expired"}))
      assert({:ok} = AuthorisationSession.authorized?(account_user, member, %Session{status: "pending"}))
    end

    test "Session member role observer", %{account_user: account_user} do
      member = %SessionMember{role: "observer"}
      assert({:ok} = AuthorisationSession.authorized?(account_user, member, %Session{status: "open"}))
      assert({:ok} = AuthorisationSession.authorized?(account_user, member, %Session{status: "close"}))
      assert({:error, _} = AuthorisationSession.authorized?(account_user, member, %Session{status: "expired"}))
      assert({:error, _} = AuthorisationSession.authorized?(account_user, member, %Session{status: "pending"}))
    end
  end

  describe "No Account Manager and faciltitator" do
    setup do
      {:ok, account_user: %AccountUser{role: "faciltitator"}}
    end

    test "Session member role faciltitator", %{account_user: account_user} do
      member = %SessionMember{role: "faciltitator"}
      assert({:ok} = AuthorisationSession.authorized?(account_user, member, %Session{status: "open"}))
      assert({:ok} = AuthorisationSession.authorized?(account_user, member, %Session{status: "close"}))
      assert({:ok} = AuthorisationSession.authorized?(account_user, member, %Session{status: "expired"}))
      assert({:ok} = AuthorisationSession.authorized?(account_user, member, %Session{status: "pending"}))
  end

    test "Session member role participant", %{account_user: account_user} do
      member = %SessionMember{role: "participant"}
      assert({:ok} = AuthorisationSession.authorized?(account_user, member, %Session{status: "open"}))
      assert({:error, _} = AuthorisationSession.authorized?(account_user, member, %Session{status: "close"}))
      assert({:error, _} = AuthorisationSession.authorized?(account_user, member, %Session{status: "expired"}))
      assert({:error, _} = AuthorisationSession.authorized?(account_user, member, %Session{status: "pending"}))
    end

    test "Session member role observer", %{account_user: account_user} do
      member = %SessionMember{role: "observer"}
      assert({:ok} = AuthorisationSession.authorized?(account_user, member, %Session{status: "open"}))
      assert({:ok} = AuthorisationSession.authorized?(account_user, member, %Session{status: "close"}))
      assert({:error, _} = AuthorisationSession.authorized?(account_user, member, %Session{status: "expired"}))
      assert({:error, _} = AuthorisationSession.authorized?(account_user, member, %Session{status: "pending"}))
    end
  end
end
