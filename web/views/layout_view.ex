defmodule KlziiChat.LayoutView do
  use KlziiChat.Web, :view

  def path_to_assets(nil, path), do: Path.expand("./web/static/assets") <> path
  def path_to_assets(_, path), do: path

  def brand_logo_path(nil, %{url: url, static: false}), do: url.full
  def brand_logo_path(nil, %{url: url, static: true}), do: Path.expand("./web/static/assets") <> url.full
  def brand_logo_path(_, %{url: url, static: false}), do: url.full
  def brand_logo_path(_, %{url: url, static: true}), do: url.full

  def path_to_js_css(nil, path), do: Path.expand("./web/static") <> path
  def path_to_js_css(_, path), do: path
end
