defmodule KlziiChat.Services.ReportingServiceTest do
  use KlziiChat.SessionMemberCase
  alias KlziiChat.Services.MessageService

  setup %{session: session, session_topic_1: session_topic_1, member: member, member2: member2} do
    {:ok, session_id: session.id, session_topic_id: session_topic_1.id, member_id: member.id, member2_id: member2.id}
  end

  test "convert topic history to CSV", %{member_id: member_id, session_topic_id: session_topic_id} do
    MessageService.history(session_topic_id, member_id)
    |> IO.inspect
  end

end
