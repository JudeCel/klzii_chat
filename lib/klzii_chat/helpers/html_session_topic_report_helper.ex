defmodule KlziiChat.Helpers.HTMLSessionTopcReportHelper do
  require EEx

  EEx.function_from_file(
    :def,
    :html_from_template,
    Path.expand("./web/templates/reporting/report_layout.html.eex"),
    [:assigns]
  )

  EEx.function_from_file(
    :def,
    :html_table_from_template,
    Path.expand("./web/templates/reporting/report_table.html.eex"),
    [:assigns]
  )

  EEx.function_from_file(
    :def,
    :html_emoticon_script_from_template,
    Path.expand("./web/templates/reporting/report_emoticon_script_template.html.eex"),
    [:assigns]
  )
end
