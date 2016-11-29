defmodule KlziiChat.BackgroundTasks.SessionTopic do
  alias KlziiChat.Services.{SessionTopicService}
  import KlziiChat.Helpers.IntegerHelper
  alias KlziiChat.{Endpoint}
  alias KlziiChat.BackgroundTasks.{General}

  def perform(session_id) do
    update_session_topics(session_id)
  end

  def update_session_topics(session_id) do
    case SessionTopicService.get_related_session_topics(get_num(session_id)) do
      {:ok, session_topics} ->
        data = Phoenix.View.render_many(session_topics, KlziiChat.SessionTopicView, "show.json", as: :session_topic)
        Endpoint.broadcast!("sessions:#{session_id}", "update_session_topics", %{session_topics: data})
      {:error, reason} ->
       {:error, %{reason: reason}}
    end
  end

  def update(session_member_id, session_id)  do
    General.run_task(fn -> update_session_topics_for_member(session_member_id, session_id)end)
  end

  def update_session_topics_for_member(session_member_id, session_id) do
    case SessionTopicService.get_related_session_topics(get_num(session_id)) do
      {:ok, session_topics} ->
        data = Phoenix.View.render_many(session_topics, KlziiChat.SessionTopicView, "show.json", as: :session_topic)
        Endpoint.broadcast!("sessions:#{session_id}", "update_session_topics_for_member", %{session_topics: data, session_member_id: session_member_id})
      {:error, reason} ->
       {:error, %{reason: reason}}
    end
  end

end
