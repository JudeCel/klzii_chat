defmodule KlziiChat.Services.WhiteboardReportingServiceTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.WhiteboardService
  alias KlziiChat.Services.WhiteboardReportingService

  setup %{session_topic_1: session_topic_1, facilitator: facilitator, participant: participant} do
    {:ok, create_date1} = Ecto.DateTime.cast("2016-05-20T09:50:00Z")
    {:ok, create_date2} = Ecto.DateTime.cast("2016-05-20T09:55:00Z")

    event1 =
      """
      {"id": "polylineSioylgpvpbf", "action": "draw", "element": {"attr": {"fill": "#e51e39", "style": "stroke-width: 2;", "points": "785.5416564941406,234.41665649414062,789.5416564941406,241.41665649414062,790.5416564941406,253.41665649414062,795.5416564941406,261.4166564941406,798.5416564941406,270.4166564941406,807.5416564941406,282.4166564941406,809.5416564941406,294.4166564941406,815.5416564941406,305.4166564941406,818.5416564941406,313.4166564941406,825.5416564941406,323.4166564941406,826.5416564941406,329.4166564941406,827.5416564941406,334.4166564941406,829.5416564941406,335.4166564941406,830.5416564941406,338.4166564941406,835.5416564941406,342.4166564941406,835.5416564941406,346.4166564941406,837.5416564941406,349.4166564941406,839.5416564941406,349.4166564941406,839.5416564941406,349.4166564941406,839.5416564941406,350.4166564941406,843.5416564941406,350.4166564941406,843.5416564941406,353.4166564941406", "stroke": "#ff0000", "transform": "matrix(1,0.0017,-0.0017,1,0,0)"}, "type": "polyline"}, "userName": "Facilitator - AccountManager"}
      """
    event2 =
      """
      {"id": "imageSioylgpvp46", "action": "draw", "element": {"attr": {"x": "10", "y": "20", "href": "/images/logo.png", "width": "200", "height": "100", "transform": "matrix(1,0.0017,-0.0017,1,0.1223,-0.1919)", "preserveAspectRatio": "none"}, "type": "image"}, "userName": "Facilitator - AccountManager"}
      """


    Ecto.build_assoc(
      session_topic_1, :shapes,
      sessionTopicId: session_topic_1.id,
      sessionMemberId: facilitator.id,
      uid: "lineSiovhiuqt29",
      event: Poison.decode!(event1),
      createdAt: create_date1,
      updatedAt: create_date1
    ) |> Repo.insert!()

    Ecto.build_assoc(
      session_topic_1, :shapes,
      sessionTopicId: session_topic_1.id,
      sessionMemberId: participant.id,
      uid: "lineSiovhiuqt37",
      event: Poison.decode!(event2),
      createdAt: create_date2,
      updatedAt: create_date2
    ) |> Repo.insert!()

    {:ok, session_topic: session_topic_1, event1: event1}
  end

  test "get all events", %{session_topic: session_topic, event1: event1} do
    events = WhiteboardReportingService.get_all_events(session_topic.id)
    assert(Enum.count(events) == 2)
    assert(List.first(events) == Poison.decode!(event1))
  end

  test "create PDF report", %{session_topic: session_topic} do
    {:ok, path_to_pdf} = WhiteboardReportingService.save_report("WhiteboardReportingServiceTest", :pdf, session_topic.id)

    assert(File.exists?(path_to_pdf))

    :ok = File.rm(path_to_pdf)
  end

end
