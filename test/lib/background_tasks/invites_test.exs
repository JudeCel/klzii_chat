defmodule KlziiChat.BackgroundTasks.InvitesTest do
  use KlziiChat.{ ModelCase, SessionMemberCase }
  alias KlziiChat.BackgroundTasks.Invites
  alias KlziiChat.{Invite}

  setup %{session: session, account: account, participant: participant} do
    invite =
      %Invite{
        accountId: account.id,
        accountUserId: participant.accountUserId,
        sessionId: session.id,
        status: "pending",
        token: "token",
        sentAt: Timex.now(),
        emailStatus: "sent",
        role: participant.role
      }
      |> Repo.insert!()


    {:ok, invite: invite}
  end

  describe "notify_listeners" do
    test "brodcast to channel", %{invite: invite} do
      assert({:ok} == Invites.notify_listeners(invite.id))
    end

    test "return error if not found ", %{invite: invite} do
      assert({:error, _} = Invites.notify_listeners(invite.id + 99))
    end
  end
end
