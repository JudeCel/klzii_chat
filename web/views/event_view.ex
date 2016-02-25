defmodule KlziiChat.EventView do
  use KlziiChat.Web, :view
  alias KlziiChat.SessionMembersView

  def render("events.json", %{event: event}) do
    %{
      id: event.id,
      session_member: SessionMembersView.render("member.json", %{member: event.session_member}),
      event: event.event,
      tag: event.tag,
      replyId: event.replyId,
      time: event.createdAt,
      star: event.star,
      replies: render_many(event.replies, KlziiChat.EventView, "events.json"),
      votes_count: Enum.count(event.votes)
    }
  end

  def render("event.json", %{event: event}) do
    %{
      id: event.id,
      session_member: SessionMembersView.render("member.json", %{member: event.session_member}),
      event: event.event,
      tag: event.tag,
      replyId: event.replyId,
      time: event.createdAt,
      star: event.star,
      replies: render_many(event.replies, KlziiChat.EventView, "events.json"),
      votes_count: Enum.count(event.votes)
    }
  end
end
