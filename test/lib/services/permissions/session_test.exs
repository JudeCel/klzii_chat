defmodule KlziiChat.Services.Permissions.SessionTest do
  use ExUnit.Case, async: true
  alias KlziiChat.Services.Permissions.Session, as: SessionPermissions
  alias KlziiChat.{Session, SessionMember, AccountUser}
  use Timex

  describe "Account Manager" do
    setup do
      open_session = %Session{status: "open", startTime: Timex.shift(Timex.now, days: -1), endTime: Timex.shift(Timex.now, days: 3) }
      close_session = %Session{status: "closed", startTime: Timex.shift(Timex.now, days: -1), endTime: Timex.shift(Timex.now, days: 3)}
      expired_session = %Session{status: "open", startTime: Timex.shift(Timex.now, days: 1), endTime: Timex.shift(Timex.now, days: 3) }
      pending_session = %Session{status: "open", startTime: Timex.shift(Timex.now, days: 1), endTime: Timex.shift(Timex.now, days: 3) }

      {:ok,
        open_session: open_session,
        close_session: close_session,
        expired_session: expired_session,
        pending_session: pending_session,
        account_user: %AccountUser{role: "accountManager"},
        facilitator: %SessionMember{role: "facilitator"},
        participant: %SessionMember{role: "participant"},
        observer: %SessionMember{role: "observer"}
      }
    end

    test "Session member role facilitator", context do
      member = %SessionMember{role: "facilitator"}
      assert({:ok} = SessionPermissions.can_access?(context.account_user, member, context.open_session))
      assert({:ok} = SessionPermissions.can_access?(context.account_user, member, context.close_session))
      assert({:ok} = SessionPermissions.can_access?(context.account_user, member, context.expired_session))
      assert({:ok} = SessionPermissions.can_access?(context.account_user, member, context.pending_session))
    end

    test "Session member role participant", context do
      assert({:ok} = SessionPermissions.can_access?(context.account_user, context.participant, context.open_session))
      assert({:ok} = SessionPermissions.can_access?(context.account_user, context.participant, context.close_session))
      assert({:ok} = SessionPermissions.can_access?(context.account_user, context.participant, context.expired_session))
      assert({:ok} = SessionPermissions.can_access?(context.account_user, context.participant, context.pending_session))
    end

    test "Session member role observer", context do
      assert({:ok} = SessionPermissions.can_access?(context.account_user, context.observer, context.open_session))
      assert({:ok} = SessionPermissions.can_access?(context.account_user, context.observer, context.close_session))
      assert({:error, _} = SessionPermissions.can_access?(context.account_user, context.observer, context.expired_session))
      assert({:error, _} = SessionPermissions.can_access?(context.account_user, context.observer, context.pending_session))
    end
  end

  describe "No Account Manager and facilitator" do
    setup do
      open_session = %Session{status: "open", startTime: Timex.shift(Timex.now, days: -1), endTime: Timex.shift(Timex.now, days: 3) }
      close_session = %Session{status: "closed", startTime: Timex.shift(Timex.now, days: -1), endTime: Timex.shift(Timex.now, days: 3)}
      expired_session = %Session{status: "open", startTime: Timex.shift(Timex.now, days: 1), endTime: Timex.shift(Timex.now, days: 3) }
      pending_session = %Session{status: "open", startTime: Timex.shift(Timex.now, days: 1), endTime: Timex.shift(Timex.now, days: 3) }

      {:ok,
        open_session: open_session,
        close_session: close_session,
        expired_session: expired_session,
        pending_session: pending_session,
        account_user: %AccountUser{role: "facilitator"},
        facilitator: %SessionMember{role: "facilitator"},
        participant: %SessionMember{role: "participant"},
        observer: %SessionMember{role: "observer"}
      }
    end

    test "Session member role facilitator", context do
      assert({:ok} = SessionPermissions.can_access?(context.account_user, context.facilitator, context.open_session))
      assert({:ok} = SessionPermissions.can_access?(context.account_user, context.facilitator, context.close_session))
      assert({:ok} = SessionPermissions.can_access?(context.account_user, context.facilitator, context.expired_session))
      assert({:ok} = SessionPermissions.can_access?(context.account_user, context.facilitator, context.pending_session))
  end

    test "Session member role participant", context do
      assert({:ok} = SessionPermissions.can_access?(context.account_user, context.participant, context.open_session))
      assert({:error, _} = SessionPermissions.can_access?(context.account_user, context.participant, context.close_session))
      assert({:error, _} = SessionPermissions.can_access?(context.account_user, context.participant, context.expired_session))
      assert({:error, _} = SessionPermissions.can_access?(context.account_user, context.participant, context.pending_session))
    end

    test "Session member role observer", context do
      assert({:ok} = SessionPermissions.can_access?(context.account_user, context.observer, context.open_session))
      assert({:ok} = SessionPermissions.can_access?(context.account_user, context.observer, context.close_session))
      assert({:error, _} = SessionPermissions.can_access?(context.account_user, context.observer, context.expired_session))
      assert({:error, _} = SessionPermissions.can_access?(context.account_user, context.observer, context.pending_session))
    end
  end
end
