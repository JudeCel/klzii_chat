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

  def render("messages.json", %{ messages: messages, prevPage: prev_page }) do
    read = messages["read"] || [];
    unread = messages["unread"] || [];
    per_page = KlziiChat.Services.DirectMessageService.per_page()

    %{
      read: render_many(read, KlziiChat.DirectMessageView, "show.json", as: :message),
      unread: render_many(unread, KlziiChat.DirectMessageView, "show.json", as: :message),
      currentPage: prev_page + div(length(read) + length(unread), per_page)
    }
  end
end
