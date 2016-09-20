defmodule KlziiChat.LayoutView do
  use KlziiChat.Web, :view


  def report_logo_url do
    "/images/klzii_logo.png"
  end

  def path_to_assets(nil, path), do: Path.expand("./web/static/assets") <> path
  def path_to_assets(_, path), do: path

  def path_to_js_css(nil, path), do: Path.expand("./web/static") <> path
  def path_to_js_css(_, path), do: path
end
