defmodule KlziiChat.Monitoring.ErrorChannel do
  use KlziiChat.Web, :channel
  alias KlziiChat.Services.ConnectionLogService

  intercept []

  def join("error:member", %{"token" => "token"}, socket) do
    {:ok, socket}
  end
  def join("error:" <> server_name, _, socket) do
    {:ok, socket}
  end
end
