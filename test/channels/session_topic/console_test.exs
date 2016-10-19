defmodule KlziiChat.Channels.SessionTopic.ConsoleTest do
  use KlziiChat.ChannelCase
  use KlziiChat.SessionMemberCase
  alias KlziiChat.{Repo, UserSocket, SessionTopicChannel}
  alias KlziiChat.Services.{SessionResourcesService}

  setup %{session: session, session_topic_1: session_topic_1, facilitator: facilitator, participant: participant} do
    Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})
    session_topic_1_name =  "session_topic:" <> Integer.to_string(session_topic_1.id)
    { :ok, jwt1, _encoded_claims } =  Guardian.encode_and_sign(facilitator)
    { :ok, jwt2, _encoded_claims } =  Guardian.encode_and_sign(participant)

    {:ok, socket} = connect(UserSocket, %{"token" => jwt1})
    {:ok, socket2} = connect(UserSocket, %{"token" => jwt2})

    mini_survey = Ecto.build_assoc(
     session, :mini_surveys,
     sessionTopicId: session_topic_1.id,
     type: "yesNoMaybe",
     question: "cool question",
     title: "cool title"
   ) |> Repo.insert!


    {:ok, socket: socket, socket2: socket2, session_topic_1_name: session_topic_1_name, mini_survey_id: mini_survey.id}
  end

  test "when unauthorized", %{socket: socket, session_topic_1_name: session_topic_1_name} do
    {:error,  %{reason: "unauthorized"}} = join(socket, SessionTopicChannel, session_topic_1_name <> "2233")
  end

  test "receive console on subscribing", %{socket: socket, session_topic_1_name: session_topic_1_name} do
    {:ok, _, _} = subscribe_and_join(socket, SessionTopicChannel, session_topic_1_name)
    assert_push("console", %{})
  end

  test "enable pinboard", %{socket: socket, session_topic_1_name: session_topic_1_name} do
    {:ok, _, socket} = subscribe_and_join(socket, SessionTopicChannel, session_topic_1_name)

    ref = push socket, "enable_pinboard", %{}
    assert_reply ref, :ok, %{}
    
    assert_push("console", %{})
  end

  test "disable pinboard", %{socket: socket, session_topic_1_name: session_topic_1_name} do
    {:ok, _, socket} = subscribe_and_join(socket, SessionTopicChannel, session_topic_1_name)

    ref = push socket, "disable_pinboard", %{}
    assert_reply ref, :ok, %{}
    
    assert_push("console", %{})
  end

  test "create mini survey", %{socket: socket, session_topic_1_name: session_topic_1_name} do
    {:ok, _, socket} = subscribe_and_join(socket, SessionTopicChannel, session_topic_1_name)

    params = %{"type" => "yesNoMaybe", "question" => "cool question", "title" => "cool title"}
    ref = push socket, "create_mini_survey", params
    assert_reply ref, :ok, %{}
  end

  test "delete mini survey", %{socket: socket, session_topic_1_name: session_topic_1_name, mini_survey_id: mini_survey_id} do
    {:ok, _, socket} = subscribe_and_join(socket, SessionTopicChannel, session_topic_1_name)
    delete_ref = push socket, "delete_mini_survey", %{ id: mini_survey_id }
    assert_reply(delete_ref, :ok, %{ id: ^mini_survey_id })
  end

  test "get mini surveys", %{socket: socket, session_topic_1_name: session_topic_1_name, mini_survey_id: mini_survey_id} do
    {:ok, _, socket} = subscribe_and_join(socket, SessionTopicChannel, session_topic_1_name)
    push_ref = push socket, "mini_surveys", %{}
    assert_reply push_ref, :ok, %{ mini_surveys: [%{ id: ^mini_survey_id }] }
  end

  test "answere mini surveys", %{socket: socket, session_topic_1_name: session_topic_1_name, mini_survey_id: mini_survey_id} do
    {:ok, _, socket} = subscribe_and_join(socket, SessionTopicChannel, session_topic_1_name)
    push_ref = push socket, "answer_mini_survey", %{ "id"=> mini_survey_id, "answer" => %{"type" => "yesNoMaybe", "value" => "yes" } }
    assert_reply push_ref, :ok, %{id: ^mini_survey_id}
  end

  test "show mini survey in console", %{socket: socket, session_topic_1_name: session_topic_1_name, mini_survey_id: mini_survey_id} do
    {:ok, _, socket} = subscribe_and_join(socket, SessionTopicChannel, session_topic_1_name)
    push_ref = push socket, "show_mini_survey",  %{ "id"=> mini_survey_id }
    assert_reply push_ref, :ok, %{id: ^mini_survey_id}
  end

  test "show mini surveys with answeres", %{socket: socket, session_topic_1_name: session_topic_1_name, mini_survey_id: mini_survey_id} do
    {:ok, _, socket} = subscribe_and_join(socket, SessionTopicChannel, session_topic_1_name)
    push_ref = push socket, "show_mini_survey_answers", %{ id: mini_survey_id }
    assert_reply push_ref, :ok, %{ id: ^mini_survey_id }
  end

  test "set mini survey to console", %{mini_survey_id: mini_survey_id, socket: socket,session_topic_1_name: session_topic_1_name} do
    {:ok, _, socket} = subscribe_and_join(socket, SessionTopicChannel, session_topic_1_name)

    ref = push socket, "set_console_mini_survey", %{ "id" => mini_survey_id }
    assert_reply ref, :ok
    assert_push("console", %{mini_survey_id: ^mini_survey_id})
  end

  test "delete mini survey when enable in console", %{mini_survey_id: mini_survey_id, socket: socket, session_topic_1_name: session_topic_1_name} do
    {:ok, _, socket} = subscribe_and_join(socket, SessionTopicChannel, session_topic_1_name)

    ref = push socket, "set_console_mini_survey", %{ "id" => mini_survey_id }
    assert_reply ref, :ok
    assert_push("console", %{mini_survey_id: ^mini_survey_id})

    delete_ref = push socket, "delete_mini_survey", %{ id: mini_survey_id }
    assert_reply delete_ref, :ok, delete_resp
    assert(delete_resp == %{id: mini_survey_id})
    assert_broadcast("console", %{ mini_survey_id: nil })
  end

  test "remove mini survey from console ", %{mini_survey_id: mini_survey_id, socket: socket,session_topic_1_name: session_topic_1_name} do
    {:ok, _, socket} = subscribe_and_join(socket, SessionTopicChannel, session_topic_1_name)
    ref = push socket, "set_console_mini_survey", %{ "id" => mini_survey_id }
    assert_reply ref, :ok
    mini_survey_id = mini_survey_id
    assert_push("console", %{ mini_survey_id: ^mini_survey_id })

    ref = push socket, "remove_console_element", %{ "type" => "miniSurvey" }
    assert_reply ref, :ok
    assert_push("console", %{ mini_survey_id: nil })
  end

  test "set resource to console", %{account_user_account_manager: account_user, socket: socket, session_topic_1_name: session_topic_1_name} do
    resource = Ecto.build_assoc(
      account_user.account, :resources,
      accountUserId: account_user.id,
      name: "test video 1",
      type: "video",
      scope: "collage"
    ) |> Repo.insert!

    resource_id = resource.id
    {:ok, _, socket} = subscribe_and_join(socket, SessionTopicChannel, session_topic_1_name)
    ref = push socket, "set_console_resource", %{"id" => resource_id}
    assert_reply ref, :ok
    assert_push("console", %{ video_id: ^resource_id })
  end

  test "remove resource from console ", %{socket: socket, session_topic_1_name: session_topic_1_name} do
    {:ok, _, socket} = subscribe_and_join(socket, SessionTopicChannel, session_topic_1_name)
    ref = push socket, "remove_console_element", %{"type" => "image"}
    assert_reply ref, :ok
    assert_push("console", %{})
  end

  test "remove resource from console when resource enable", %{account_user_account_manager: account_user, socket: socket, session_topic_1_name: session_topic_1_name} do
    {:ok, _, socket} = subscribe_and_join(socket, SessionTopicChannel, session_topic_1_name)
    assert_push("console", %{})

    resource = Ecto.build_assoc(
      account_user.account, :resources,
      accountUserId: account_user.id,
      name: "test video 1",
      type: "video",
      scope: "collage"
    ) |> Repo.insert!

    {:ok, session_resources} = SessionResourcesService.add_session_resources(resource.id, socket.assigns.session_member.id)
    session_resource = List.first(session_resources)

    ref = push socket, "set_console_resource", %{"id" => session_resource.resourceId}
    assert_reply ref, :ok, %{}

    {:ok, _} = SessionResourcesService.delete(socket.assigns.session_member.id, session_resource.id)

    assert_push("console", %{audio_id: nil, file_id: nil, pinboard: false, mini_survey_id: nil, video_id: nil})
  end
end
