defmodule KlziiChat.LayoutView do
  use KlziiChat.Web, :view

  def report_logo_url() do
    "/images/klzii_logo.png"
  end

  def header_title(assigns) do
    assigns.header_title
  end
end
