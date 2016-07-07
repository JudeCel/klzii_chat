defmodule KlziiChat.Services.SessionTopicService do
  alias KlziiChat.{Repo, SessionMember, SessionTopic}
  alias KlziiChat.Services.Permissions.SessionTopic, as: SessionTopicPermissions
  alias KlziiChat.Queries.Messages, as: QueriesMessages
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
        Ecto.Changeset.change(session_topic, boardMessage: message) |> Repo.update
      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec get_messages(integer, boolean, boolean) :: Map
  def get_messages(session_topic_id, filter_star, include_facilitator) do
    QueriesMessages.session_topic_messages(session_topic_id, star: filter_star, facilitator: include_facilitator)
    |> Repo.all()
  end

  @spec get_session_topic_wsession(integer) :: Map.t
  def get_session_topic_wsession(session_topic_id) do
    Repo.one!(
      from session_topic in SessionTopic,
      where: session_topic.id == ^session_topic_id,
      preload: [:session]
    )
  end
end
