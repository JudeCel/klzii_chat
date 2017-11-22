defmodule KlziiChat.Helpers.SocketHelper do
  alias KlziiChat.{Presence, Repo, AccountUser}
  alias KlziiChat.Dashboard.Presence, as: DashboardPresence

  @spec get_session_member(%Phoenix.Socket{}) :: Map.t
  def get_session_member(socket) do
    # get account user in order to be able to check account_user.role across whole system
    account_user_id = Map.get(socket.assigns.session_member, "account_user_id")
    account_user_summary = case account_user_id do
      nil -> %{}
      _ ->
        account_user = Repo.get!(AccountUser, socket.assigns.session_member.account_user_id)
      %{
        id: account_user.id,
        role: account_user.role,
        firstName: account_user.firstName,
        lastName: account_user.lastName,
      }
    end
    Map.put_new(socket.assigns.session_member, :account_user, account_user_summary)
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
