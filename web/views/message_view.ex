defmodule KlziiChat.MessageView do
  use KlziiChat.Web, :view
  import KlziiChat.Services.Permissions.ErrorsHelper, only: [to_boolean: 1]
  alias KlziiChat.SessionMembersView
  alias KlziiChat.Services.Permissions.Messages, as: MessagePermissions
  alias KlziiChat.Decorators.MessageDecorator

  @spec render(String.t, Map.t) :: Map.t
  def render("show.json", %{message: message, member: member}) do
    %{
      id: message.id,
      session_member: SessionMembersView.render("status.json", %{member: message.session_member}),
      body: message.body,
      replyId: message.replyId,
      time: message.createdAt,
      star: message.star,
      reply_session_member: reply_session_member(message.reply),
      emotion: message.emotion,
      replies: Enum.map(message.replies, fn r ->
        reply_info = %{ member: message.session_member}
        render("reply.json", %{message: r, member: member, reply_info: reply_info})
      end),
      votes_count: MessageDecorator.votes_count(message.votes),
      has_voted: MessageDecorator.has_voted(message.votes, member.id),
      unread: MessageDecorator.is_unread(unreaded_messages(message.unread_messages), member.id),
      permissions: %{
        can_edit: MessagePermissions.can_edit(member, message) |> to_boolean,
        can_delete: MessagePermissions.can_delete(member, message) |> to_boolean,
        can_star: MessagePermissions.can_star(member, message) |> to_boolean,
        can_vote: MessagePermissions.can_vote(member, message) |> to_boolean,
        can_reply: MessagePermissions.can_reply(member, message) |> to_boolean,
        can_new_message: MessagePermissions.can_new_message(member) |> to_boolean
      }
    }
  end
  def render("reply.json", %{message: message, member: member, reply_info: reply_info}) do
    map = render("show.json", %{message: message, member: member})
    reply_session_member = SessionMembersView.render("status.json", %{member: reply_info.member})
    Map.put(map, :reply_session_member, reply_session_member)
  end

  @spec render(String.t, Map.t) :: Map.t
  def render("report.json", %{message: message}) do
    %{
      id: message.id,
      session_member: SessionMembersView.render("report.json", %{member: message.session_member}),
      body: message.body,
      reply_prefix: "",
      replyId: message.replyId,
      replyLevel: message.replyLevel,
      time: message.createdAt,
      star: message.star,
      emotion: message.emotion,
      createdAt: message.createdAt,
      replies: Enum.map(replies(message.replies), fn m ->
        render("reply_report.json", %{message: m, reply_info: %{prefix: message.session_member.username }})
      end),
    }
  end

  def render("reply_report.json", %{message: message, reply_info: reply_info}) do
    map = render("report.json", %{message: message})
    Map.put(map, :reply_prefix, prefix_name(reply_info))
  end

  defp unreaded_messages(%{__struct__: Ecto.Association.NotLoaded}), do: []
  defp unreaded_messages(unreaded_messages), do: unreaded_messages
  defp replies(%{__struct__: Ecto.Association.NotLoaded}), do: []
  defp replies(replies), do: replies

  defp prefix_name(reply_info) do
    "@" <> reply_info.prefix
  end

  defp reply_session_member(%{__struct__: Ecto.Association.NotLoaded}), do: nil
  defp reply_session_member(message) do
    SessionMembersView.render("status.json", %{member: message.session_member});
  end
end
