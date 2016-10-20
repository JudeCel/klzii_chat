defmodule KlziiChat.Services.Reports.Formats.Pdf do
  @spec to_string(Map.t) :: {String.t}
  def to_string(%{session: session, header_title: header_title}) do
    Phoenix.View.render_to_string(
      KlziiChat.Reporting.PreviewView, "messages.html",
      session_topics: session.session_topics,
      brand_logo: session.brand_logo,
      header_title: header_title,
      layout: {KlziiChat.LayoutView, "report.html"}
    )
  end
end
