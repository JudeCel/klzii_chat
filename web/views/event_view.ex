defmodule KlziiChat.EventView do
  use KlziiChat.Web, :view
  alias KlziiChat.SessionMembersView

  def render("events.json", %{event: event}) do
    %{
      id: event.id,
      session_member: render_one(event.session_member, SessionMembersView, "session_member.json"),
      event: event.event,
      tag: event.tag,
      time: event.createdAt
    }
  end

  def render("event.json", %{event: event}) do
    %{
      id: event.id,
      session_member: render_one(event.session_member, SessionMembersView, "session_member.json"),
      event: event.event,
      tag: event.tag,
      time: event.createdAt
    }
  end
end
