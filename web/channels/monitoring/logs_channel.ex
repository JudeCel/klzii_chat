defmodule KlziiChat.Monitoring.LogsChannel do
  use KlziiChat.Web, :channel
  alias KlziiChat.Services.ConnectionLogService

  intercept []

  def join("logs:member", %{"token" => "token"}, socket) do
    {:ok, socket}
  end

  def join("logs:" <> server_name, _, socket) do
    {:ok, socket}
  end
end
