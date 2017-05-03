defmodule KlziiChat.SessionTopicView do
  use KlziiChat.Web, :view

  def render("show.json", %{session_topic: session_topic}) do
    %{id: session_topic.id,
      name: session_topic.name,
      boardMessage: session_topic.boardMessage,
      landing: session_topic.landing,
      sign: session_topic.sign,
      session: session(session_topic.session),
      default: get_default_topic(session_topic.topic),
      inviteAgain: get_invite_again_topic(session_topic.topic)
    }
  end

  def render("report_statistic.json", %{session_topic: session_topic}) do
    %{
      id: session_topic.id,
      name: session_topic.name,
      order: session_topic.order
    }
  end

  def render("report.json", %{session_topic: session_topic}) do
    %{
      id: session_topic.id,
      name: session_topic.name,
      boardMessage: session_topic.boardMessage,
      session: session(session_topic.session),
      messages: messages(session_topic.messages),
      mini_surveys: mini_surveys(session_topic.mini_surveys),
      shapes: shapes(session_topic.shapes)
    }
  end

  def session(%{__struct__: Ecto.Association.NotLoaded}), do: nil
  def session(session) do
    render_one(session, KlziiChat.SessionView, "session.json", as: :session)
  end

  def shapes(%{__struct__: Ecto.Association.NotLoaded}), do: []
  def shapes(shapes) do
    render_many(shapes, KlziiChat.ShapeView, "report.json", as: :shape)
  end

  def messages(%{__struct__: Ecto.Association.NotLoaded}), do: []
  def messages(messages) do
    render_many(messages, KlziiChat.MessageView, "report.json", as: :message)
  end

  def mini_surveys(%{__struct__: Ecto.Association.NotLoaded}), do: []
  def mini_surveys(mini_surveys) do
    render_many(mini_surveys, KlziiChat.MiniSurveyView, "report.json", as: :mini_survey)
  end

  def get_default_topic(%{__struct__: Ecto.Association.NotLoaded}), do: nil
  def get_default_topic(topic), do: topic.default

  def get_invite_again_topic(%{__struct__: Ecto.Association.NotLoaded}), do: nil
  def get_invite_again_topic(topic), do: topic.inviteAgain
end
