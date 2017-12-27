defmodule KlziiChat.Helpers.SocketHelper do
  alias KlziiChat.{Presence}
  alias KlziiChat.Dashboard.Presence, as: DashboardPresence

  @spec get_session_member(%Phoenix.Socket{}) :: Map.t
  def get_session_member(socket) do
    socket.assigns.session_member
  end

  @spec get_account_user(%Phoenix.Socket{}) :: Map.t
  def get_account_user(socket) do
    socket.assigns.account_user
  end

  @spec track(%Phoenix.Socket{}) :: {:ok, String.t}
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

  @spec track_dashboard(%Phoenix.Socket{}) :: {:ok, String.t}
  def track_dashboard(socket) do
    # we not track Presence for test
    case Mix.env do
      :test ->
        {:ok, "ok"}
      _ ->
        DashboardPresence.track(socket, (get_account_user(socket).id |> to_string), %{
          online_at: inspect(System.system_time(:seconds))
        })
    end
  end
end
