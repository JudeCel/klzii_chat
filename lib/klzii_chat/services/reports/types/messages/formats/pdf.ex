defmodule KlziiChat.Services.Reports.Types.Messages.Formats.Pdf do

  @spec processe_data(Map.t) :: {String.t}
  def processe_data(data) do
    render_string(data)
  end

  @spec render_string( Map.t) :: {:ok, String.t} | {:error, Map.t}
  def render_string(data) do
    try do
      header =
        Phoenix.View.render_to_string(
          KlziiChat.Reporting.PreviewView, "header.html",
          brand_logo: get_in(data, ["session", :brand_logo]),
          header_title: get_in(data, ["header_title"])
        )
      body =
        Phoenix.View.render_to_string(
          KlziiChat.Reporting.PreviewView, "session_topics_messages.html",
          session_topics: get_in(data, ["session_topics"]),
          session: get_in(data, ["session"]),
          brand_logo: get_in(data, ["session", :brand_logo]),
          header_title: get_in(data, ["header_title"]),
          layout: {KlziiChat.LayoutView, "report.html"}
        )
      {:ok, %{body: body, header: header}}
    rescue
      e in RuntimeError ->
        {:error, e}
    end
  end
end
