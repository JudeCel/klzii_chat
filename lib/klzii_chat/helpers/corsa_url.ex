defmodule KlziiChat.Helpers.CorsaUrl do
  def compile_url do
    {:ok, regexp} = Regex.compile(System.get_env("CORS_URL") || "^https?://(.*\.?)focus\.com" )
    regexp
  end
end
