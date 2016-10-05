defmodule KlziiChat.SessionTopicView do
  use KlziiChat.Web, :view

  def render("show.json", %{session_topic: session_topic}) do
    %{id: session_topic.id,
      name: session_topic.name,
      boardMessage: session_topic.boardMessage,
      landing: session_topic.landing,
      session: session(session_topic.session)
    }
  end

  def session(%{__struct__: Ecto.Association.NotLoaded}), do: nil

  def session(session) do
    render_one(session, KlziiChat.SessionView, "session.json", as: :session)
  end
end
