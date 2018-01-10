defmodule KlziiChat.Helpers.CorsaUrl do
  def compile_url do
    ["^https?://(.*\.?)cliizii\.com",
      "^https?://(.*\.?)cliizii\.chat",
      "^https?://(.*\.?)focus\.com",
      "^https?://(.*\.?)kliiko\.diatomdemo\.com",
      "^https?://(.*\.?)test\.cliizii\.com",
      "^https?://(.*\.?)test\.klzii\.com"
    ]
    |> Enum.map(fn url ->
      compile_regex(url)
    end)
    |>  Enum.reject(&(&1 == nil))
  end

  def compile_regex(nil), do: nil
  def compile_regex(url), do: Regex.compile!(url)
end
