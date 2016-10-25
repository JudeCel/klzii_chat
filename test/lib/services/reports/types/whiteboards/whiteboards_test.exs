defmodule KlziiChat.Services.Reports.Types.WhiteboardsTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.Reports.Types.Whiteboards
  alias KlziiChat.Services.SessionReportingService

  setup %{session_topic_1: session_topic, facilitator: facilitator} do
    payload_pdf =  %{"sessionTopicId" => session_topic.id, "format" => "pdf", "type" => "whiteboards", "scopes" => %{} }
    {:ok, topic_report} = SessionReportingService.create_report(facilitator.id, payload_pdf)

    only_session =  %{"format" => "pdf", "type" => "whiteboards", "scopes" => %{} }
    {:ok, session_report} = SessionReportingService.create_report(facilitator.id, only_session)

    {:ok, topic_report: topic_report, session_report: session_report}
  end

  describe "get_data topic report" do
    setup %{topic_report: topic_report} do
      {:ok, data} = Whiteboards.get_data(topic_report)
      {:ok, data: data}
    end

    test "structure", %{data: data} do
      assert(
        %{"session" => _, "header_title" => _} = data
      )
    end
  end

  describe "get_data session report" do
    setup %{session_report: session_report} do
      {:ok, data} = Whiteboards.get_data(session_report)
      {:ok, data: data}
    end

    test "structure", %{data: data} do
      assert(
        %{"session" => _, "header_title" => _} = data
      )
    end
  end
end
