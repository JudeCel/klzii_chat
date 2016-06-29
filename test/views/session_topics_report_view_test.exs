defmodule KlziiChat.SessionTopicsReportViewTest do
  alias KlziiChat.SessionTopicsReportView
  use ExUnit.Case, async: true

  test "Convert report" do
    ecto_report =
      %KlziiChat.SessionTopicReport{__meta__: ~s(:loaded, "SessionTopicsReports"),
      createdAt: Ecto.DateTime.cast("2016-06-20 18:17:36"), facilitator: true,
      format: "pdf", id: 409, message: nil, resource: nil, resourceId: nil,
      session: "association :session is not loaded",
      sessionId: 4634, sessionTopicId: 9267,
      session_topic: "association :session_topic is not loaded",
      status: "progress", type: "whiteboard",
      updatedAt: Ecto.DateTime.cast("2016-06-20 18:17:36")}

    json_report =
      %{facilitator: true, format: "pdf", id: 409, message: nil, resource: nil,
      resourceId: nil, sessionId: 4634, sessionTopicId: 9267, status: "progress",
      type: "whiteboard"}

    assert(json_report == SessionTopicsReportView.render("show.json", %{report: ecto_report}))
    Poison
  end

  test "Convert reports" do
    ecto_reports =
      [%KlziiChat.SessionTopicReport{__meta__: ~s(:loaded, "SessionTopicsReports"),
        createdAt: Ecto.DateTime.cast("2016-06-20 18:17:36"), facilitator: true,
        format: "pdf", id: 409, message: nil, resource: nil, resourceId: nil,
        session: "association :session is not loaded",
        sessionId: 4634, sessionTopicId: 9267,
        session_topic: "association :session_topic is not loaded",
        status: "progress", type: "whiteboard",
        updatedAt: Ecto.DateTime.cast("2016-06-20 18:17:36")},
       %KlziiChat.SessionTopicReport{__meta__: ~s(:loaded, "SessionTopicsReports"),
        createdAt: Ecto.DateTime.cast("2016-06-20 18:17:36"), facilitator: false,
        format: "csv", id: 410, message: nil, resource: nil, resourceId: nil,
        session: "association :session is not loaded",
        sessionId: 4634, sessionTopicId: 9267,
        session_topic: "association :session_topic is not loaded",
        status: "progress", type: "all",
        updatedAt: Ecto.DateTime.cast("2016-06-20 18:17:36")},
       %KlziiChat.SessionTopicReport{__meta__: ~s(:loaded, "SessionTopicsReports"),
        createdAt: Ecto.DateTime.cast("2016-06-20 18:17:36"), facilitator: false,
        format: "pdf", id: 410, message: nil, resource: nil, resourceId: nil,
        session: "association :session is not loaded",
        sessionId: 4634, sessionTopicId: 9267,
        session_topic: "association :session_topic is not loaded",
        status: "progress", type: "all",
        updatedAt: Ecto.DateTime.cast("2016-06-20 18:17:36")}]

    json_reports =
      %{
        "9267" => %{
          "csv" => %{
            "all" => %{facilitator: false, format: "csv", id: 410,
              message: nil, resource: nil, resourceId: nil, sessionId: 4634,
              sessionTopicId: 9267, status: "progress", type: "all"}
          },
          "pdf" => %{
            "all" => %{facilitator: false, format: "pdf", id: 410,
              message: nil, resource: nil, resourceId: nil, sessionId: 4634,
              sessionTopicId: 9267, status: "progress", type: "all"},
            "whiteboard" => %{facilitator: true, format: "pdf", id: 409, message: nil,
              resource: nil, resourceId: nil, sessionId: 4634, sessionTopicId: 9267,
              status: "progress", type: "whiteboard"}
          }
        }
      }

    assert(json_reports == SessionTopicsReportView.render("reports.json", %{reports: ecto_reports}))
  end
end
