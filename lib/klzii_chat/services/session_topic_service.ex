defmodule KlziiChat.Services.SessionTopicService do
  alias KlziiChat.{Repo, SessionMember, SessionTopic, Topic}
  alias KlziiChat.Services.Permissions.SessionTopic, as: SessionTopicPermissions

  def errors_messages do
    %{
      action_not_allowed:  "Action not allowed!"
    }
  end

  @spec board_message(Integer, Integer, Map) :: {:ok, Map} | {:error, String.t}
  def board_message(session_member_id, session_topic_id, %{"message" => message}) do
    session_member = Repo.get!(SessionMember, session_member_id) |> Repo.preload(:account_user)

    case SessionTopicPermissions.can_board_message(session_member) do
      {:ok} ->
        Repo.transaction(fn ->
          with {:ok, session_topic} <- session_topic_board_message(session_topic_id, message)
            do session_topic
          else
            error -> Repo.rollback(error)
          end
        end)
      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec session_topic_board_message(Integer, String) :: {:ok, Map} | {:error, String.t}
  defp session_topic_board_message(session_topic_id, message) do
    Repo.get!(SessionTopic, session_topic_id)
    |> Repo.preload([:topic])
    |> SessionTopic.changeset(%{ boardMessage: message})
    |> Repo.update
  end

  @spec topic_board_message(Integer, String) :: {:ok, Map} | {:error, String.t}
  defp topic_board_message(topic_id, message) do
    Repo.get!(Topic, topic_id)
    |> Topic.changeset(%{ boardMessage: message})
    |> Repo.update
  end

  @spec get_related_session_topics(Integer) :: {:ok, Map} | {:error, String.t}
  def get_related_session_topics(session_id) do
    session_topics =
      KlziiChat.Queries.SessionTopic.all(session_id)
      |> Repo.all
    {:ok, session_topics}
  end

end
