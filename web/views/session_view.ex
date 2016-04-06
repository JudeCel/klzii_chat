defmodule KlziiChat.SessionView do
  use KlziiChat.Web, :view
  alias KlziiChat.TopicView

  def render("session.json", %{session: session}) do
    %{id: session.id,
      name: session.name,
      startTime: session.startTime,
      endTime: session.endTime,
      colours: session.brand_project_preference.colours,
      topics: Enum.map(session.topics, fn t ->
        TopicView.render("topic.json", %{topic: t })
      end)
    }
  end
end
