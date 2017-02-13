defmodule KlziiChat.Admin.LogsChannel do
  use KlziiChat.Web, :channel
  alias KlziiChat.{Repo}


  intercept ["pull_update"]

  def join("logs:pull", _, socket) do
    {:ok, socket}
  end

  def handle_out("pull_update", payload, socket) do
    push socket, "pull_update", payload
    {:noreply, socket}
  end

end
