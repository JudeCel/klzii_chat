defmodule KlziiChat.EventView do
  use KlziiChat.Web, :view
  alias KlziiChat.SessionMembersView
  alias KlziiChat.Services.Permissions

  @spec render(String.t, Map.t) :: Map.t
  def render("whiteboard_event.json", %{event: event}) do
    %{
      id: event.id,
      event: event.event,
      tag: event.tag,
      replyId: event.replyId,
      time: event.createdAt,
      star: event.star,
    }
  end

  @spec render(String.t, Map.t) :: Map.t
  def render("event.json", %{event: event, member: member}) do
    %{
      id: event.id,
      session_member: SessionMembersView.render("member.json", %{member: event.session_member}),
      event: event.event,
      tag: event.tag,
      replyId: event.replyId,
      sessionMemberId: event.sessionMemberId,
      time: event.createdAt,
      star: event.star,
      replies: Enum.map(event.replies, fn r ->
        render("event.json", %{event: r, member: member})
      end),
      votes_count: votes_count(event.votes),
      votes_ids: votes_ids(event.votes),
      has_voted: false,
      permissions: %{
        can_edit: false,
        can_delete: false,
        can_star: false,
        can_vote: false,
        can_reply: false
      }
    }
  end

  @spec votes_count(List.t) :: Integer.t
  defp votes_count(votes) do
    Enum.count(votes)
  end

  @spec votes_ids(List.t) :: List.t
  defp votes_ids(votes) do
    Enum.map(votes, &(&1.sessionMemberId))
  end
end
