defmodule KlziiChat.Corsica.Router do
  use Corsica.Router,
    allow_headers: ~w(accept cache-control pragma authorization content-type)

  resource "/uploads/*", origins: [Regex.compile("^https?://(.*\.?)focus\.com" || System.get_env("CORS_URL"))]
  resource "/api/*", origins: [Regex.compile("^https?://(.*\.?)focus\.com" || System.get_env("CORS_URL"))]
  resource "/*", origins: "*"
end
