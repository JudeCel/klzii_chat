defmodule KlziiChat.Services.NotificationServiceTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.{NotificationService}

  describe "send notification" do
    test "if online", %{session: session, participant: participant} do
      active_users = %{ to_string(participant.id) => %{} }
      res = NotificationService.send_notification_if_need(participant.id, active_users, session.id, "private_message")
      assert({:ok, false} = res)
    end

    test "if offline", %{session: session, participant: participant} do
      active_users = %{ }
      res = NotificationService.send_notification_if_need(participant.id, active_users, session.id, "chat_message")
      assert({:ok, true} = res)
    end

    test "if ghost", %{session_social: session_social, participant_ghost: participant_ghost} do
      active_users = %{ to_string(participant_ghost.id) => %{} }
      res = NotificationService.send_notification_if_need(participant_ghost.id, active_users, session_social.id, "private_message")
      assert({:ok, false} = res)
    end
  end

end
