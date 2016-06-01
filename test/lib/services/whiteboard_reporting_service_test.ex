defmodule KlziiChat.Services.ReportingServiceTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.WhiteboardService

  setup %{session: session, session_topic_1: session_topic_1, member: member, member2: member2} do
    {:ok, create_date1} = Ecto.DateTime.cast("2016-05-20T09:50:00Z")
    {:ok, create_date2} = Ecto.DateTime.cast("2016-05-20T09:55:00Z")

    event1 =
      """
      {"id": "lineSiovhiuqt2o", "action": "draw", "element": {"attr": {"x1": "432.875", "x2": "376.875", "y1": "267.3125", "y2": "99.3125", "fill": "undefined", "style": "stroke-width: 2;", "stroke": "#e51e39", "transform": "matrix(1,0.0017,-0.0017,1,0.173,-0.6567)"}, "type": "line"}, "userName": "Facilitator - AccountManager"}
      """
    event2 =
      """
      {"id": "lineSiovhiuqt37", "action": "draw", "element": {"attr": {"x1": "116.875", "x2": "141.875", "y1": "367.3125", "y2": "88.3125", "fill": "undefined", "style": "stroke-width: 2;", "stroke": "#e51e39", "transform": "matrix(1,0.0017,-0.0017,1,0.1535,-0.2466)"}, "type": "line"}, "userName": "Facilitator - AccountManager"}
      """


    Ecto.build_assoc(
      session_topic_1, :shapes,
      sessionTopicId: session_topic_1.id,
      sessionMemberId: member.id,
      uid: "lineSiovhiuqt29",
      event: Poison.decode!(event1),
      createdAt: create_date1
    ) |> Repo.insert!()

    Ecto.build_assoc(
      session_topic_1, :shapes,
      sessionTopicId: session_topic_1.id,
      sessionMemberId: member2.id,
      uid: "lineSiovhiuqt37",
      event: Poison.decode!(event2),
      createdAt: create_date2
    ) |> Repo.insert!()

    {:ok, session_topic: session_topic_1}
  end

  test "white board history", %{session_topic: session_topic} do
    WhiteboardService.history(session_topic.id)
    |> IO.inspect()
  end

end
