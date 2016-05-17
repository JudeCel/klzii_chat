defmodule KlziiChat.SessionTopicView do
  use KlziiChat.Web, :view

  def render("show.json", %{session_topic: session_topic}) do
    %{id: session_topic.id,
      name: session_topic.name
    }
  end
end
