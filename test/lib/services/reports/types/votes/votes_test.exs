defmodule KlziiChat.Services.Reports.Types.BaseTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.Reports.Types.Votes
  alias KlziiChat.Services.SessionReportingService

  setup %{session_topic_1: session_topic, facilitator: facilitator} do
    payload_pdf =  %{"sessionTopicId" => session_topic.id, "format" => "pdf", "type" => "votes", "includeFields" => ["city", "state"] }
    {:ok, topic_report} = SessionReportingService.create_report(facilitator.id, payload_pdf)

    payload_csv =  %{"format" => "csv", "type" => "votes", "scopes" => %{} }
    {:ok, session_report} = SessionReportingService.create_report(facilitator.id, payload_csv)

    {:ok, topic_report: topic_report, session_report: session_report}
  end

  describe "get_data topic report" do
    setup %{topic_report: topic_report} do
      {:ok, data} = Votes.Base.get_data(topic_report)
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
      assert({:ok, Votes.Formats.Pdf} == Votes.Base.format_modeule("pdf"))
    end

    test "csv" do
      assert({:ok, Votes.Formats.Csv} == Votes.Base.format_modeule("csv"))
    end

    test "txt" do
      assert({:ok, Votes.Formats.Txt} == Votes.Base.format_modeule("txt"))
    end

    test "not exists" do
      module = "bar"
      assert({:error, "module for format #{module} not found"} == Votes.Base.format_modeule(module))
    end
  end

  describe "get_data session report" do
    setup %{session_report: session_report} do
      {:ok, data} = Votes.Base.get_data(session_report)
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
