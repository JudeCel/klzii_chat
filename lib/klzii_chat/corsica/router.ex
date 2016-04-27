defmodule KlziiChat.Corsica.Router do
  use Corsica.Router,
    allow_headers: ~w(accept cache-control pragma authorization content-type)

  resource "/uploads/*", origins: [get_url_regexp]
  resource "/api/*", origins: [get_url_regexp]
  resource "/*", origins: "*"

  def get_url_regexp do
    {:ok, regexp} = Regex.compile(System.get_env("CORS_URL") || "^https?://(.*\.?)focus\.com" )
    regexp
  end
end
