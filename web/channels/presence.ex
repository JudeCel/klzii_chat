defmodule KlziiChat.Presence do
  alias KlziiChat.{SessionMembersView, Repo, SessionMember}
  use Phoenix.Presence, otp_app: :klzii_chat, pubsub_server: KlziiChat.PubSub

  import Ecto
  import Ecto.Query, only: [from: 2]

  def fetch("session_topic:" <> _id, entries) do
    session_members = ge_session_members(entries) |> Enum.into(%{})

    for {key, %{metas: metas}} <- entries, into: %{} do
      {key, %{metas: metas, member: SessionMembersView.render("status.json", member: session_members[String.to_integer(key)])}}
    end
  end

  def fetch("sessions:"<> _id, entries) do
    session_members = ge_session_members(entries) |> Enum.into(%{})

    for {key, %{metas: metas}} <- entries, into: %{} do
      {key, %{metas: metas, member: SessionMembersView.render("member.json", member: session_members[String.to_integer(key)])}}
    end
  end

  defp ge_session_members(entries) do
    (from sm in SessionMember,
      where: sm.id in ^Map.keys(entries),
      select: {sm.id, sm}
    )
    |> Repo.all
  end
end
