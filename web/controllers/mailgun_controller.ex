defmodule KlziiChat.MailgunController do
  use KlziiChat.Web, :controller
  alias KlziiChat.Services.MailgunService

  def webhooks(conn, params) do
    case MailgunService.mailgun_webhooks(params) do
      {:ok, _} ->
        send_resp(conn, 200, "ok")
      {:error, reason} ->
        send_resp(conn, 500, Poison.encode!(reason))
    end
  end

  def info(conn, params) do
    IO.inspect(params)
    send_resp(conn, 200, Poison.encode!(params))
  end
end
