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

  def render("messages.json", %{ messages: messages, prevPage: prevPage }) do
    read = messages["read"] || [];
    unread = messages["unread"] || [];

    %{
      read: render_many(read, KlziiChat.DirectMessageView, "show.json", as: :message),
      unread: render_many(unread, KlziiChat.DirectMessageView, "show.json", as: :message),
      currentPage: prevPage + div(length(read) + length(unread), 10)
    }
  end
end
