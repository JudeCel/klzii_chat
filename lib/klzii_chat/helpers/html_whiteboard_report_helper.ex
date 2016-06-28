defmodule KlziiChat.Helpers.HTMLWhiteboardReportHelper do
  require EEx

  EEx.function_from_file(
    :def,
    :html_from_template,
    Path.expand("./web/templates/reporting/whiteboard_report.html.eex"),
    [:assigns]
  )
end
