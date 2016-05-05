defmodule KlziiChat.Presence do
  alias KlziiChat.{Repo, SessionMember, SessionMembersView}
  import Ecto
  import Ecto.Query, only: [from: 1, from: 2]
  use Phoenix.Presence, otp_app: :klzii_chat, pubsub_server: KlziiChat.PubSub

  def fetch(_topic, entries) do
    query =
      from sm in SessionMember,
        where: sm.id in ^Map.keys(entries),
        select: {sm.id, sm}

    members = query |> Repo.all |> Enum.into(%{})

    for {key, %{metas: metas}} <- entries, into: %{} do
      id = String.to_integer(key)
      {key, %{metas: metas, member: SessionMembersView.render("status.json", member: members[id])}}
    end
  end
end
