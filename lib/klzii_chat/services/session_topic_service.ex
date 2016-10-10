defmodule KlziiChat.Services.SessionTopicService do
  alias KlziiChat.{Repo, SessionMember, SessionTopic}
  alias KlziiChat.Services.Permissions.SessionTopic, as: SessionTopicPermissions
  import Ecto.Query, only: [from: 2]

  def errors_messages do
    %{
      action_not_allowed:  "Action not allowed!"
    }
  end

  @spec board_message(Integer, Integer, Map) :: {:ok, Map } | {:error, String.t}
  def board_message(session_member_id, session_topic_id, %{"message" => message}) do
    session_member = Repo.get!(SessionMember, session_member_id)
    session_topic = Repo.get!(SessionTopic, session_topic_id)

    case SessionTopicPermissions.can_board_message(session_member) do
      {:ok} ->
        SessionTopic.changeset(session_topic, %{ boardMessage: message}) |> Repo.update
      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec get_by_session(Integer) :: {:ok, Map } | {:error, String.t}
  def get_by_session(session_id) do
    session_topics = KlziiChat.Queries.SessionTopic.all(session_id) |> Repo.all
    {:ok, session_topics}
  end

end
