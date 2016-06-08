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

    {:ok, session: session, session_topic: session_topic_1}
  end

  test "Get random string" do
    refute(ReportingService.get_random_str() == ReportingService.get_random_str())
  end

  test "Get report name", %{session: session, session_topic: session_topic} do
    ReportingService.create_session_topic_report(:messages, session_topic.id, :pdf, false, false)
  end

end
