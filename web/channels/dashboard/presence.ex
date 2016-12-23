defmodule KlziiChat.Dashboard.Presence do
  alias KlziiChat.{Repo, AccountUser, AccountUserView}
  use Phoenix.Presence, otp_app: :klzii_chat, pubsub_server: KlziiChat.PubSub
  import Ecto.Query, only: [from: 2]

  def fetch("sessionsBuilder:"<> _id, entries) do
    account_users = get_account_users(entries) |> Enum.into(%{})
    for {key, %{metas: metas}} <- entries, into: %{} do
      {key, %{metas: metas, accountUser: AccountUserView.render("show.json", %{account_user: account_users[String.to_integer(key)]})}}
    end
  end

  defp get_account_users(entries) do
    (from au in AccountUser,
      where: au.id in ^Map.keys(entries),
      select: {au.id, au}
    )
    |> Repo.all
  end
end
