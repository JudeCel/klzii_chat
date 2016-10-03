defmodule KlziiChat.Helpers.SocketHelper do
  alias KlziiChat.{Presence}

  @spec get_session_member(%Phoenix.Socket{}) :: Map.t
  def get_session_member(socket) do
    socket.assigns.session_member
  end

  @spec get_session_member(%Phoenix.Socket{}) :: {:ok, String.t}
  def track(socket) do
    # we not track Presence for test
    case Mix.env do
      :test ->
        {:ok, "ok"}
      _ ->
        Presence.track(socket, (get_session_member(socket).id |> to_string), %{
          online_at: inspect(System.system_time(:seconds))
        })
    end
  end
end
