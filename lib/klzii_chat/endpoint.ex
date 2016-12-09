defmodule KlziiChat.Endpoint do
  use Phoenix.Endpoint, otp_app: :klzii_chat

  socket "/socket", KlziiChat.UserSocket
  socket "/socketDashboard", KlziiChat.UserDashboardSocket

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug KlziiChat.Corsica.Router
  plug Plug.Static,
    at: "/", from: :klzii_chat, gzip: true,
    only: ~w(uploads css fonts images sounds js images/avatar favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  if Application.get_env(:klzii_chat, :sql_sandbox) do
    plug Phoenix.Ecto.SQL.Sandbox
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison,
    length: 5_000_000

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_klzii_chat_key",
    signing_salt: "Rkjb13qZ",
    log: :debug

  plug KlziiChat.Router
end
