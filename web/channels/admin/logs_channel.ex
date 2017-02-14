defmodule KlziiChat.Admin.LogsChannel do
  use KlziiChat.Web, :channel
  alias KlziiChat.{Repo}


  intercept ["new_log_entry"]

  def join("logs:pull", _, socket) do
    {:ok, socket}
  end

  def handle_out("new_log_entry", payload, socket) do
    push socket, "new_log_entry", payload
    {:noreply, socket}
  end

end
