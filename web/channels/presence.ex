defmodule KlziiChat.Presence do
  alias KlziiChat.{SessionMember, SessionMembersView}
  use Phoenix.Presence, otp_app: :klzii_chat, pubsub_server: KlziiChat.PubSub

  def fetch(_topic, entries) do
    for {key, %{metas: metas}} <- entries, into: %{} do
      {key, %{metas: metas, member: SessionMembersView.render("status.json", member: List.first(metas))}}
    end
  end
end
