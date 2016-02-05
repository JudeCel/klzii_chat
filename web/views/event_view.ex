defmodule KlziiChat.EventView do
  use KlziiChat.Web, :view
  def render("event.json", %{username: username, event: event}) do
    %{id: event.id,
      username: username,
      body: event.event["body"],
      time: event.createdAt
    }
  end
end
