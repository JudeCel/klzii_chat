defmodule KlziiChat.Helpers.CorsaUrl do
  def compile_url do
    [System.get_env("CORS_URL"), "^https?://(.*\.?)focus\.com", "^https?://(.*\.?)kliiko\.diatomdemo\.com"]
    |> Enum.map(fn url ->
      compile_regex(url)
    end) |>  Enum.reject(&(&1 == nil))
  end

  def compile_regex(nil), do: nil
  def compile_regex(url), do: Regex.compile!(url)
end
