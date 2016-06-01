defmodule KlziiChat.Services.SessionTopicService do
  alias KlziiChat.{Repo, SessionMember, SessionTopic, SessionMember}
  alias KlziiChat.Services.Permissions.SessionTopic, as: SessionTopicPermissions
  alias KlziiChat.Queries.Messages, as: QueriesMessages

  @spec board_message(Integer, Integer, Map) :: {:ok, Map } | {:error, String.t}
  def board_message(session_member_id, session_topic_id, %{"message" => message}) do
    session_member = Repo.get!(SessionMember, session_member_id)
    session_topic = Repo.get!(SessionTopic, session_topic_id)
    if SessionTopicPermissions.can_board_message(session_member) do
      Ecto.Changeset.change(session_topic, boardMessage: message) |> Repo.update
    else
      {:error, "Action not allowed!"}
    end
  end

  @spec message_history(integer, boolean, boolean) :: {:ok, Map }
  def message_history(session_topic_id, stars_only, exclude_facilitator) do
    query =
      QueriesMessages.base_query(session_topic_id, stars_only)
      |> QueriesMessages.join_session_member()

    if exclude_facilitator, do: query = QueriesMessages.exclude_facilitator(query)

    query = QueriesMessages.sort_select(query)

    {:ok, Repo.all(query)}
  end
end
