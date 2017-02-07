defmodule KlziiChat.Services.NotificationServiceTest do
  use KlziiChat.{ModelCase, SessionMemberCase}

  setup %{session: session, facilitator: facilitator, participant: participant} do
    {:ok, participant: participant, parent_message: parent_message, session_name: session.name}
  end

  describe "send notification" do
    test "if online", %{session_name: session_name, participant: participant} do
      #todo: 
    end

    test "if offline", %{session_name: session_name, participant: participant} do
      #todo: 
    end
  end

end
