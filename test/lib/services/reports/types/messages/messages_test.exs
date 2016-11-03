defmodule KlziiChat.Services.Reports.Types.MessagesTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.Reports.Types.Messages
  alias KlziiChat.Services.SessionReportingService

  setup %{session_topic_1: session_topic, facilitator: facilitator, participant: participant, contact_list: contact_list} do
    Ecto.build_assoc(
      session_topic, :messages,
      sessionTopicId: session_topic.id,
      sessionMemberId: facilitator.id,
      body: "test message 1",
      emotion: 0,
      star: true,
      replyLevel: 0,
    ) |> Repo.insert!()

    Ecto.build_assoc(
      session_topic, :messages,
      sessionTopicId: session_topic.id,
      sessionMemberId: participant.id,
      body: "test message 2",
      emotion: 1,
      star: false,
      replyLevel: 0,
    ) |> Repo.insert!()

    payload_pdf =  %{"sessionTopicId" => session_topic.id, "format" => "pdf",
      "type" => "messages",
      "includeFields" => Enum.concat(["city", "state"], Enum.take(contact_list.customFields, 2)) 
    }
    {:ok, topic_report} = SessionReportingService.create_report(facilitator.id, payload_pdf)

    payload_csv =  %{"format" => "csv", "type" => "messages", "scopes" => %{} }
    {:ok, session_report} = SessionReportingService.create_report(facilitator.id, payload_csv)

    {:ok, topic_report: topic_report, session_report: session_report}
  end

  describe "get_data topic report" do
    setup %{topic_report: topic_report} do
      {:ok, data} = Messages.Base.get_data(topic_report)
      {:ok, data: data}
    end

    test "structure", %{data: data} do
      assert(
      %{"session" => _, "header_title" => _, "session_topics" => [_]} = data
      )
    end
  end

  describe "get_data session report" do
    setup %{session_report: session_report} do
      {:ok, data} = Messages.Base.get_data(session_report)
      {:ok, data: data}
    end

    test "structure", %{data: data} do
      assert(
        %{"session" => _, "header_title" => _, "session_topics" => [_,_]} = data
      )
    end

    test "get_session", %{session_report: session_report, session_topic_1: session_topic_1} do
    sessionId = session_topic_1.sessionId
    assert({:ok, %{id: ^sessionId}} = Messages.Base.get_session(session_report))
    end
  end
end
