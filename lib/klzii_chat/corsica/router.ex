defmodule KlziiChat.Corsica.Router do
  use Corsica.Router,
    allow_headers: ~w(accept cache-control pragma authorization content-type)

  resource "/uploads/*", origins: [Regex.compile(System.get_env("CORS_URL") || "^https?://(.*\.?)focus\.com")]
  resource "/api/*", origins: [Regex.compile(System.get_env("CORS_URL") || "^https?://(.*\.?)focus\.com" )]
  resource "/*", origins: "*"
end
