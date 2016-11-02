defmodule KlziiChat.SessionTopicsReportViewTest do
  alias KlziiChat.SessionTopicsReportView
  use ExUnit.Case, async: true

  test "Convert reports" do
    ecto_reports =
      [%KlziiChat.SessionTopicsReport{__meta__: ~s(:loaded, "SessionTopicsReports"),
        createdAt: Ecto.DateTime.cast("2016-06-20 18:17:36"),
        format: "pdf", id: 409, message: nil, resource: nil, resourceId: nil,
        session: "association :session is not loaded",
        sessionId: 4634, sessionTopicId: nil,
        session_topic: "association :session_topic is not loaded",
        status: "progress", type: "whiteboards",
        updatedAt: Ecto.DateTime.cast("2016-06-20 18:17:36")},

       %KlziiChat.SessionTopicsReport{__meta__: ~s(:loaded, "SessionTopicsReports"),
        createdAt: Ecto.DateTime.cast("2016-06-20 18:17:36"),
        format: "pdf", id: 410, message: nil, resource: nil, resourceId: nil,
        session: "association :session is not loaded",
        sessionId: 4634, sessionTopicId: 9267,
        session_topic: "association :session_topic is not loaded",
        status: "progress", type: "whiteboards",
        updatedAt: Ecto.DateTime.cast("2016-06-20 18:17:36")},

       %KlziiChat.SessionTopicsReport{__meta__: ~s(:loaded, "SessionTopicsReports"),
        createdAt: Ecto.DateTime.cast("2016-06-20 18:17:36"),
        format: "csv", id: 411, message: nil, resource: nil, resourceId: nil,
        session: "association :session is not loaded",
        sessionId: 4634, sessionTopicId: 9267,
        session_topic: "association :session_topic is not loaded",
        status: "progress", type: "messages",
        updatedAt: Ecto.DateTime.cast("2016-06-20 18:17:36")}
      ]

    json_reports =
      %{
        "all" => %{
          "pdf" => %{
            "whiteboards" => %{includes: %{}, format: "pdf", id: 409,
              message: nil, resource: nil, resourceId: nil, sessionId: 4634,
              sessionTopicId: "all", status: "progress", type: "whiteboards"}
          }
        },
        "9267" => %{
          "pdf" => %{
            "whiteboards" => %{includes: %{},format: "pdf", id: 410, message: nil,
              resource: nil, resourceId: nil, sessionId: 4634, sessionTopicId: 9267,
              status: "progress", type: "whiteboards"}
          },
          "csv" => %{
            "messages" => %{includes: %{}, format: "csv", id: 411,
              message: nil, resource: nil, resourceId: nil, sessionId: 4634,
              sessionTopicId: 9267, status: "progress", type: "messages"},
          }
        }
      }
    assert(json_reports == SessionTopicsReportView.render("reports.json", %{reports: ecto_reports}))
  end
end
