defmodule KlziiChat.Helpers.HTMLMiniSurveysReportHelper do
  require EEx

  EEx.function_from_file(
     :def,
     :html_from_template,
     Path.expand("./web/templates/reporting/minisurveys_report_layout.html.eex"),
     [:assigns]
  )

  EEx.function_from_file(
    :def,
    :html_avatars_script_from_template,
    Path.expand("./web/templates/reporting/minisurveys_report_avatars_script.html.eex"),
    [:assigns]
  )

  EEx.function_from_file(
    :def,
    :html_survey_table_from_template,
    Path.expand("./web/templates/reporting/minisurveys_report_table.html.eex"),
    [:assigns]
  )
end
