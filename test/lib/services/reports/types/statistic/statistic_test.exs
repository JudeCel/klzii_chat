defmodule KlziiChat.Services.Reports.Types.StatisticTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.Reports.Types.Statistic
  alias KlziiChat.Services.SessionReportingService

  setup %{session_topic_1: session_topic, facilitator: facilitator, participant: participant} do
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


    payload_csv =  %{"format" => "csv", "type" => "statistic", "scopes" => %{} }
    {:ok, session_report} = SessionReportingService.create_report(facilitator.id, payload_csv)

    {:ok, session_report: session_report}
  end

  describe "format_modeule" do

    test "csv" do
      assert({:ok, Statistic.Formats.Csv} == Statistic.Base.format_modeule("csv"))
    end

    test "not exists" do
      module = "bar"
      assert({:error, "module for format #{module} not found"} == Statistic.Base.format_modeule(module))
    end
  end

  describe "get_data session report" do
    setup %{session_report: session_report} do
      {:ok, data} = Statistic.Base.get_data(session_report)
      {:ok, data: data}
    end

    test "structure", %{data: data} do
      assert(
        %{"session" => session, "header_title" => header_title, "statistic" => statistic, "fields" => fields} = data
      )

      assert(is_map(session))
      assert(is_bitstring(header_title))
      assert(is_map(statistic))
      assert(is_list(fields))
    end

    test "get_session", %{session_report: session_report, session_topic_1: session_topic_1} do
    sessionId = session_topic_1.sessionId
    assert({:ok, %{id: ^sessionId}} = Statistic.Base.get_session(session_report))
    end
  end

  describe "get_statistic" do
    test "return statistic for each session members", %{session_report: session_report} do
      {:ok, statistic} = Statistic.Base.get_statistic(session_report)
      assert(Map.keys(statistic) |> length == 4)
    end
  end
end
