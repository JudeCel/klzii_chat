defmodule KlziiChat.Monitoring.InfoChannel do
  use KlziiChat.Web, :channel
  alias KlziiChat.Services.ConnectionLogService

  intercept []

  def join("info:member", %{"token" => "token"}, socket) do
    {:ok, socket}
  end
  def join("info:" <> server_name, _, socket) do
    {:ok, socket}
  end
end
