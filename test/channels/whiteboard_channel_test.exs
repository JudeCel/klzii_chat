defmodule KlziiChat.WhiteboardChannelTest do
  use KlziiChat.ChannelCase
  use KlziiChat.SessionMemberCase
  alias KlziiChat.{Repo, UserSocket, WhiteboardChannel}

  setup %{session_topic_1: session_topic_1, session: session, session: session, member: member} do
    Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})
    whiteboard_name =  "whiteboard:" <> Integer.to_string(session_topic_1.id)
    { :ok, jwt, _encoded_claims } =  Guardian.encode_and_sign(member)
    {:ok, socket} = connect(UserSocket, %{"token" => jwt})
    {:ok, socket: socket, whiteboard_name: whiteboard_name}
  end

  test "when unauthorized", %{socket: socket, whiteboard_name: whiteboard_name} do
    {:error,  %{reason: "unauthorized"}} = subscribe_and_join(socket, WhiteboardChannel, whiteboard_name <> "2233")
  end

  test "can join and get history ", %{socket: socket, whiteboard_name: whiteboard_name} do
    {:ok, replay, _socket} = subscribe_and_join(socket, WhiteboardChannel, whiteboard_name)
    is_list(replay) |> assert
  end

  test "can push new shape", %{socket: socket, whiteboard_name: whiteboard_name} do
      socket = subscribe_and_join!(socket, WhiteboardChannel, whiteboard_name)

      body = %{"type" => "23", "id" => "12"}
      push(socket, "draw", body)
      assert_receive(%Phoenix.Socket.Broadcast{})
      assert_push "draw", shape
      assert(shape.event == body)
  end

  test "can push update shape", %{socket: socket, whiteboard_name: whiteboard_name} do
      socket = subscribe_and_join!(socket, WhiteboardChannel, whiteboard_name)

      body =  %{"type" => 23, "id" => "12"}
      push(socket, "draw", body)
      assert_receive(%Phoenix.Socket.Broadcast{})

      assert_push "draw", shape
      assert(shape.event == body)

      update_body = %{"object" => %{"id" => body["id"], "event" => %{"type" => "1"} }}
      push socket, "update", update_body
      assert_receive(%Phoenix.Socket.Broadcast{})
      assert_push "update", update_shape

      assert(update_shape.event == update_body["object"] )
  end


  # test "can push delete message", %{socket: socket, whiteboard_name: whiteboard_name} do
  #   {:ok, _, socket} = subscribe_and_join(socket, SessionTopicChannel, whiteboard_name)
  #     ref = push socket, "new_message", %{"emotion" => "1", "body" => "hey!!"}
  #     assert_reply ref, :ok
  #     assert_push "new_message", message
  #
  #     ref2 = push socket, "delete_message", %{"id" => message.id}
  #     assert_reply ref2, :ok
  #
  #     assert_push "delete_message", resp
  #     assert(resp == %{id: message.id, replyId: nil})
  # end
end
