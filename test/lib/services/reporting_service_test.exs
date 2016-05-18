defmodule KlziiChat.Services.ReportingServiceTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.MessageService

  setup %{session_topic_1: session_topic_1, member: member} do
    # insert messages


    {:ok, session_topic_id: session_topic_1.id, member_id: member.id}
  end

  test "convert topic history to CSV", %{member_id: member_id, session_topic_id: session_topic_id} do
    MessageService.history(session_topic_id, member_id)
    |> IO.inspect()
  end

end
