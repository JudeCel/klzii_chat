defmodule KlziiChat.Helpers.HTMLReportingHelper do
  require EEx

  @template_path Path.expand("./web/templates/reporting/report_layout.html.eex")

  EEx.function_from_file(:def, :html_from_template, @template_path, [:assigns])
end
