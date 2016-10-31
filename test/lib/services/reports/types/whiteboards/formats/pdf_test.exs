defmodule KlziiChat.Services.Reports.Types.Formats.Whiteboards.PdfTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.SessionReportingService

  setup %{session_topic_1: session_topic, facilitator: facilitator, participant: participant, contact_list: contact_list} do
    Ecto.build_assoc(
      session_topic, :shapes,
      sessionTopicId: session_topic.id,
      sessionMemberId: facilitator.id,
      event: %{},
      uid: :calendar.universal_time |> inspect
    ) |> Repo.insert!()

    Ecto.build_assoc(
      session_topic, :shapes,
      sessionTopicId: session_topic.id,
      sessionMemberId: participant.id,
      event: %{},
      uid: :calendar.universal_time |> inspect
    ) |> Repo.insert!()

    topic_report_payload =  %{"sessionTopicId" => session_topic.id, "format" => "pdf",
      "type" => "whiteboards",
      "customFildes" =>  Enum.take(contact_list.customFields, 4)
    }

    {:ok, topic_report} = SessionReportingService.create_report(facilitator.id, topic_report_payload)
    {:ok, topic_report_data} = KlziiChat.Services.Reports.Types.Whiteboards.Base.get_data(topic_report)

    session_report_payload =  %{"format" => "pdf", "type" => "whiteboards" }
    {:ok, session_report} = SessionReportingService.create_report(facilitator.id, session_report_payload)

    {:ok, session_report_data} = KlziiChat.Services.Reports.Types.Whiteboards.Base.get_data(session_report)
    {:ok, topic_report_data: topic_report_data, session_report_data: session_report_data}
  end

  describe "whiteboards" do
    test "topic report", %{topic_report_data: topic_report_data} do
      {:ok,_} = KlziiChat.Services.Reports.Whiteboards.Formats.Pdf.processe_data(topic_report_data)
    end

    test "session report", %{session_report_data: session_report_data} do
      {:ok, _} = KlziiChat.Services.Reports.Whiteboards.Formats.Pdf.processe_data(session_report_data)
    end
  end
end
