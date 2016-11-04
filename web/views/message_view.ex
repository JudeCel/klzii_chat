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
      session_member: SessionMembersView.render("member.json", %{member: message.session_member}),
      body: message.body,
      replyId: message.replyId,
      time: message.createdAt,
      star: message.star,
      emotion: message.emotion,
      replies: Enum.map(message.replies, fn r ->
        render("show.json", %{message: r, member: member})
      end),
      votes_count: MessageDecorator.votes_count(message.votes),
      has_voted: MessageDecorator.has_voted(message.votes, member.id),
      unread: MessageDecorator.is_unread(unreaded_messages(message.unread_messages), member.id),
      permissions: %{
        can_edit: MessagePermissions.can_edit(member, message) |> to_boolean,
        can_delete: MessagePermissions.can_delete(member, message) |> to_boolean,
        can_star: MessagePermissions.can_star(member) |> to_boolean,
        can_vote: MessagePermissions.can_vote(member, message) |> to_boolean,
        can_reply: MessagePermissions.can_reply(member, message) |> to_boolean,
        can_new_message: MessagePermissions.can_new_message(member) |> to_boolean
      }
    }
  end

  @spec render(String.t, Map.t) :: Map.t
  def render("report.json", %{message: message}) do
    %{
      id: message.id,
      session_member: SessionMembersView.render("report.json", %{member: message.session_member}),
      body: message.body,
      replyId: message.replyId,
      time: message.createdAt,
      star: message.star,
      emotion: message.emotion,
      createdAt: message.createdAt,
      replies: Phoenix.View.render_many(message.replies,__MODULE__, "report.json", as: :message)
    }
  end
  
defp unreaded_messages(%{__struct__: Ecto.Association.NotLoaded}), do: []
  defp unreaded_messages(unreaded_messages), do: unreaded_messages
end
