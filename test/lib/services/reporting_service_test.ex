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
      emotion: 0,
      star: true,
    ) |> Repo.insert!()

    Ecto.build_assoc(
      session_topic_1, :messages,
      sessionTopicId: session_topic_1.id,
      sessionMemberId: participant.id,
      body: "test message 2",
      emotion: 1,
      star: false,
    ) |> Repo.insert!()

    {:ok, session: session, session_topic: session_topic_1}
  end



  test "Get report name", %{session: session, session_topic: session_topic} do
    datetime = Timex.DateTime.local()
    {:ok, datetime_string} = Timex.format(datetime, @date_time_format)

    report_name = ReportingService.get_report_name(@report_prefix, session_topic.id, datetime)
    assert(report_name == @report_prefix <> "_" <> ReportingService.remove_non_alph_chars(session.name)
      <> "_" <> ReportingService.remove_non_alph_chars(session_topic.name) <> "_" <> datetime_string)
  end

end
