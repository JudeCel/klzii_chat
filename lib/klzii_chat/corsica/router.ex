defmodule KlziiChat.Corsica.Router do
  @origins KlziiChat.Helpers.CorsaUrl.compile_url

  use Corsica.Router,
    allow_headers: ~w(accept cache-control pragma authorization content-type)

  # resource "/uploads/*", origins: @origins
  # resource "/api/*", origins: @origins
  resource "/*", origins: @origins
end
