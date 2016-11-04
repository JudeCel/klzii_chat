defmodule KlziiChat.Services.Reports.Types.Whiteboards.BaseTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.Reports.Types.Whiteboards
  alias KlziiChat.Services.SessionReportingService

  setup %{session_topic_1: session_topic, facilitator: facilitator} do
    payload_pdf =  %{"sessionTopicId" => session_topic.id, "format" => "pdf", "type" => "whiteboards", "includes" => %{} }
    {:ok, topic_report} = SessionReportingService.create_report(facilitator.id, payload_pdf)

    only_session =  %{"format" => "pdf", "type" => "whiteboards", "includes" => %{} }
    {:ok, session_report} = SessionReportingService.create_report(facilitator.id, only_session)

    {:ok, topic_report: topic_report, session_report: session_report}
  end

  describe "get_data topic report" do
    setup %{topic_report: topic_report} do
      {:ok, data} = Whiteboards.Base.get_data(topic_report)
      {:ok, data: data}
    end

    test "structure", %{data: data} do
      assert(
        %{"session" => _, "header_title" => _} = data
      )
    end
  end

  describe "format_modeule" do
    test "pdf" do
      module = "pdf"
      assert({:ok, Whiteboards.Formats.Pdf} == Whiteboards.Base.format_modeule(module))
    end

    test "csv" do
      module = "csv"
      assert({:error, "module for format #{module} not found"} == Whiteboards.Base.format_modeule(module))
    end

    test "txt" do
      module = "txt"
      assert({:error, "module for format txt not found"} == Whiteboards.Base.format_modeule(module))
    end
  end

  describe "get_data session report" do
    setup %{session_report: session_report} do
      {:ok, data} = Whiteboards.Base.get_data(session_report)
      {:ok, data: data}
    end

    test "structure", %{data: data} do
      assert(
        %{"session" => session, "header_title" => header_title, "session_topics" => session_topics, "fields" => fields} = data
      )
      assert(is_map(session))
      assert(is_bitstring(header_title))
      assert(is_list(session_topics))
      assert(is_list(fields))
    end
  end
end
