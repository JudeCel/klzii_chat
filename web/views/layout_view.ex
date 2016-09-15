defmodule KlziiChat.LayoutView do
  use KlziiChat.Web, :view

  def report_log_url() do
    ""
  end

  def header_title(assigns) do
    assigns.header_title
  end
end
