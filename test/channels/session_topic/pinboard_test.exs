defmodule KlziiChat.Channels.SessionTopic.PinboardTest do
  use KlziiChat.ChannelCase
  use KlziiChat.SessionMemberCase
  alias KlziiChat.{Repo, UserSocket, SessionTopicChannel}

  setup %{session_topic_1: session_topic_1, participant: participant, facilitator: facilitator} do
    Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})
    session_topic_1_name =  "session_topic:" <> Integer.to_string(session_topic_1.id)
    { :ok, jwt1, _encoded_claims } =  Guardian.encode_and_sign(participant)
    { :ok, jwt2, _encoded_claims } =  Guardian.encode_and_sign(facilitator)

    {:ok, socket} = connect(UserSocket, %{"token" => jwt1})
    {:ok, socket2} = connect(UserSocket, %{"token" => jwt2})

    {:ok, socket: socket, socket2: socket2, session_topic_1_name: session_topic_1_name}
  end

  test "when unauthorized", %{socket: socket, session_topic_1_name: session_topic_1_name} do
    {:error,  %{reason: "unauthorized"}} = join(socket, SessionTopicChannel, session_topic_1_name <> "2233")
  end

  test "get all pinboard resources", %{socket: socket, session_topic_1_name: session_topic_1_name} do
    {:ok, _, socket} = subscribe_and_join(socket, SessionTopicChannel, session_topic_1_name)
    ref = push socket, "get_pinboard_resources", %{}
    assert_reply ref, :ok, %{list: []}
  end

  test "delete pinboard resource", %{socket2: socket, participant: participant, session_topic_1_name: session_topic_1_name, session_topic_1: session_topic_1} do
    pinboard_resource =   Ecto.build_assoc(
      participant, :pinboard_resources,
      session_topic: session_topic_1
    ) |> Repo.insert!

    {:ok, _, socket} = subscribe_and_join(socket, SessionTopicChannel, session_topic_1_name)

    ref = push socket, "delete_pinboard_resource", %{id: pinboard_resource.id}
    assert_reply ref, :ok, %{}

    assert_broadcast("delete_pinboard_resource", %{})
  end
end
