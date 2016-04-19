defmodule KlziiChat.Corsica.Router do
  use Corsica.Router,
    allow_headers: ~w(accept cache-control pragma authorization content-type)

  resource "/uploads/*", origins: [~r{^https?://(.*\.?)focus\.com}]
  resource "/api/*", origins: [~r{^https?://(.*\.?)focus\.com}]
  resource "/*", origins: "*"
end
