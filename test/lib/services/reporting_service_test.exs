defmodule KlziiChat.Services.ReportingServiceTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.ReportingService

  @report_prefix "ReportingService_test_report"
  @date_time_format "{YYYY}_{0M}_{0D}_{h24}_{0m}"

  setup %{session: session, session_topic_1: session_topic_1, facilitator: facilitator, participant: participant} do
    Ecto.build_assoc(
      session_topic_1, :messages,
      sessionTopicId: session_topic_1.id,
      sessionMemberId: facilitator.id,
      body: "test message 1",
      emotion: 5,
      star: true,
    ) |> Repo.insert!()

    Ecto.build_assoc(
      session_topic_1, :messages,
      sessionTopicId: session_topic_1.id,
      sessionMemberId: participant.id,
      body: "test message 2",
      emotion: 3,
      star: false,
    ) |> Repo.insert!()

    {:ok, session: session, session_topic: session_topic_1, facilitator: facilitator}
  end

  test "Get report name for a given type" do
    {:ok, "Session_topic_messages_report_1"} = ReportingService.get_report_name(:all, 1)
    {:ok, "Session_topic_messages_report_2"} = ReportingService.get_report_name(:all, 2)
    {:ok, "Session_topic_messages_report_3"} = ReportingService.get_report_name(:all, 3)
    {:ok, "Session_topic_whiteboard_report_4"} =  ReportingService.get_report_name(:whiteboard, 4)
  end

end
