defmodule KlziiChat.Authorisations.Channels.SessionTopicTest do
  use KlziiChat.{ChannelCase, SessionMemberCase}
  alias KlziiChat.Authorisations.Channels.SessionTopic

  test "Session Topic authorisation succses #authorized?", %{session_topic_1: session_topic_1, facilitator: facilitator} do
    sesssion_topic_id =  session_topic_1.id
    session_member =  %{id: facilitator.id, session_id: session_topic_1.sessionId}
    socket =   Phoenix.Socket.assign(Phoenix.Socket.__struct__, :session_member, session_member)

    SessionTopic.authorized?(socket, sesssion_topic_id) |> assert
  end

  test "Session Topic authorisation Fails #authorized?", %{session_topic_1: session_topic_1, facilitator: facilitator} do
    sesssion_topic_id =  session_topic_1.id + 99
    session_member =  %{id: facilitator.id, session_id: session_topic_1.sessionId}
    socket =   Phoenix.Socket.assign(Phoenix.Socket.__struct__, :session_member, session_member)

    SessionTopic.authorized?(socket, sesssion_topic_id) |> refute
  end
end
