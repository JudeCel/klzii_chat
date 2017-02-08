defmodule KlziiChat.Services.NotificationServiceTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.{NotificationService}

  setup %{session: session, facilitator: facilitator, participant: participant} do
    {:ok, participant: participant, facilitator: facilitator, session_id: session.id}
  end

  describe "send notification" do
    test "if online", %{session_id: session_id, participant: participant} do
      active_users = %{ to_string(participant.id) => %{} }
      res = NotificationService.send_notification_if_need(participant.id, active_users, session_id, "private_message")
      assert({:ok, false} = res)
    end

    test "if offline", %{session_id: session_id, participant: participant} do
      active_users = %{ }
      res = NotificationService.send_notification_if_need(participant.id, active_users, session_id, "chat_message")
      assert({:ok, true} = res)
    end
  end

end
