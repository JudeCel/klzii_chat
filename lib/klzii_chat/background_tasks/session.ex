defmodule KlziiChat.BackgroundTasks.Session do
  alias KlziiChat.Services.{SessionTopicService}
  alias KlziiChat.{Endpoint}
  alias KlziiChat.BackgroundTasks.{General}

  def refresh(session_id) do
    General.run_task(fn -> update_session_topics(session_id) end)
  end

  defp update_session_topics(session_id) do
    case SessionTopicService.get_by_session(session_id) do
      {:ok, session_topics} ->
        data = Phoenix.View.render_many(session_topics, KlziiChat.SessionTopicView, "show.json", as: :session_topic)
        Endpoint.broadcast!("sessions:#{session_id}", "update_session_topics", %{session_topics: data})
      {:error, reason} ->
       {:error, %{reason: reason}}
    end
  end
end
