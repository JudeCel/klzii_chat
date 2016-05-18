defmodule KlziiChat.SessionView do
  use KlziiChat.Web, :view
  alias KlziiChat.SessionTopicView

  def render("session.json", %{session: session}) do
    %{id: session.id,
      name: session.name,
      startTime: session.startTime,
      endTime: session.endTime,
      colours: session.brand_project_preference.colours,
      session_topics: Enum.map(session.session_topics, fn t ->
        SessionTopicView.render("show.json", %{session_topic: t })
      end)
    }
  end
end
