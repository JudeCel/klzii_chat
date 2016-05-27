defmodule KlziiChat.Helpers.HTMLReportingHelper do
  require EEx

  @template_path Path.expand("web/templates/reporting/report_layout.html.eex")

  EEx.function_from_file(:def, :get_html, @template_path, [:assigns])
end
