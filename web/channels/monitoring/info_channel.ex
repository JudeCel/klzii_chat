defmodule KlziiChat.Monitoring.InfoChannel do
  use KlziiChat.Web, :channel
  alias KlziiChat.Services.ConnectionLogService

  intercept ["deps"]

  def join("info:listener", %{"token" => "token"}, socket) do

    {:ok, assign(socket, :type, :listener)}
  end
  def join("info:" <> server_name, _, socket) do
    assign(socket, :type, :server)
    {:ok, assign(socket, :type, :server)}
  end


  def handle_in("get_deps", _, socket) do
    {:reply, :ok, socket}
  end

  def handle_out("deps", payload, socket) do
    if(socket.assigns.type == :listener) do
      push(socket, "deps", payload)
    end
    {:noreply, socket}
  end
end
