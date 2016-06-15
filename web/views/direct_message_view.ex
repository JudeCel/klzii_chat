defmodule KlziiChat.DirectMessageView do
  use KlziiChat.Web, :view

  @spec render(String.t, Map.t) :: Map.t
  def render("show.json", %{message: message}) do
    %{
      id: message.id,
      text: message.text,
      senderId: message.senderId,
      recieverId: message.recieverId,
      readAt: message.readAt,
      createdAt: message.createdAt
    }
  end

  def render("messages.json", %{ messages: messages }) do
    %{
      read: render_many(messages["read"] || [], KlziiChat.DirectMessageView, "show.json", as: :message),
      unread: render_many(messages["unread"] || [], KlziiChat.DirectMessageView, "show.json", as: :message)
    }
  end
end
