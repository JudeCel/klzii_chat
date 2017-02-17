defmodule KlziiChat.WhiteboardChannelTest do
  use KlziiChat.ChannelCase
  use KlziiChat.SessionMemberCase
  alias KlziiChat.{Repo, UserSocket, WhiteboardChannel}

  setup %{session_topic_1: session_topic_1, facilitator: facilitator} do
    Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})
    whiteboard_name =  "whiteboard:" <> Integer.to_string(session_topic_1.id)
    { :ok, jwt, _encoded_claims } =  Guardian.encode_and_sign(facilitator)
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

      body = %{"event" => %{"type" => "iamge"}, "id" => "12"}
      push(socket, "draw", body)
      assert_receive(%Phoenix.Socket.Broadcast{})
      assert_push "draw", shape
      assert(shape.event == body)
  end

  test "can push update shape", %{socket: socket, whiteboard_name: whiteboard_name} do
      socket = subscribe_and_join!(socket, WhiteboardChannel, whiteboard_name)

      body =  %{"event" => %{"type" => "iamge"}, "id" => "12", }
      ref = push(socket, "draw", body)
      assert_reply(ref, :ok)
      assert_push "draw", shape
      assert(shape.event == body)

      update_body = %{"object" => %{"id" => body["id"], "event" => %{"type" => "1"} }}
      update_ref = push socket, "update", update_body
      assert_reply(update_ref, :ok)
      assert_push "update", update_shape

      assert(update_shape.event == update_body["object"] )
  end


  test "can push delete shape", %{socket: socket, whiteboard_name: whiteboard_name} do
    socket = subscribe_and_join!(socket, WhiteboardChannel, whiteboard_name)

    body = %{"event" => %{"type" => "iamge"}, "id" => "12"}
    ref = push(socket, "draw", body)
    assert_reply(ref, :ok)

    assert_push "draw", shape
    assert(shape.event == body)

    delete_ref = push socket, "delete", %{"uid" => body["id"]}
    assert_reply(delete_ref, :ok)
    assert_push "delete", delete_shape
    assert(delete_shape == %{uid: body["id"]})
  end

  test "can push delete all shape", %{socket: socket, whiteboard_name: whiteboard_name} do
    socket = subscribe_and_join!(socket, WhiteboardChannel, whiteboard_name)

    body = %{"event" => %{"type" => "iamge"}, "id" => "12"}
    ref = push(socket, "draw", body)
    assert_reply(ref, :ok)
    assert_push "draw", %{}

    delete_ref = push socket, "deleteAll", %{}
    assert_reply(delete_ref, :ok)
    assert_push "deleteAll", remaining_shapes
    assert(remaining_shapes == %{"shapes" => [%{uid: body["id"]}]})
  end
end
