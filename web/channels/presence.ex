defmodule KlziiChat.Presence do
  alias KlziiChat.{SessionMembersView}
  use Phoenix.Presence, otp_app: :klzii_chat, pubsub_server: KlziiChat.PubSub

  def fetch("session_topic:" <> _id, entries) do
    for {key, %{metas: metas}} <- entries, into: %{} do
      {key, %{metas: metas, member: SessionMembersView.render("status.json", member: List.first(metas))}}
    end
  end

  def fetch("sessions:"<> _id, entries) do
    for {key, %{metas: metas}} <- entries, into: %{} do
      {key, %{metas: metas, member: SessionMembersView.render("member.json", member: List.first(metas))}}
    end
  end
end
