defmodule KlziiChat.Services.Reports.Formats.CsvTest do
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

    topic_report_payload =  %{"sessionTopicId" => session_topic.id, "format" => "pdf",
      "type" => "messages",
      "customFildes" =>  Enum.take(contact_list.customFields, 4)
    }

    {:ok, topic_report} = SessionReportingService.create_report(facilitator.id, topic_report_payload)
    {:ok, topic_report_data} = Messages.Base.get_data(topic_report)

    session_report_payload =  %{"format" => "pdf", "type" => "messages" }
    {:ok, session_report} = SessionReportingService.create_report(facilitator.id, session_report_payload)

    {:ok, session_report_data} = Messages.Base.get_data(session_report)
    {:ok, topic_report_data: topic_report_data, session_report_data: session_report_data}
  end

  describe "messages" do
    test "topic report", %{topic_report_data: topic_report_data} do
      {:ok,stream} = KlziiChat.Services.Reports.Types.Messages.Formats.Csv.processe_data(topic_report_data)
    end

    test "session report", %{session_report_data: session_report_data} do
      {:ok, stream} = KlziiChat.Services.Reports.Types.Messages.Formats.Csv.processe_data(session_report_data)
      Enum.each(stream, fn(data) ->
        IO.inspect data
      end)
    end
  end
end
