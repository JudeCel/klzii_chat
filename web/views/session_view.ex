defmodule KlziiChat.SessionView do
  use KlziiChat.Web, :view
  alias KlziiChat.TopicView

  def render("session.json", %{session: session}) do
    %{id: session.id,
      name: session.name,
      start_time: session.start_time,
      end_time: session.end_time,
      topics: Enum.map(session.topics, fn t ->
        TopicView.render("topic.json", %{topic: t })
      end)
    }
  end
end
