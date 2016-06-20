defmodule KlziiChat.Services.SessionTopicService do
  alias KlziiChat.{Repo, SessionMember, SessionTopic}
  alias KlziiChat.Services.Permissions.SessionTopic, as: SessionTopicPermissions
  alias KlziiChat.Queries.Messages, as: QueriesMessages
  import Ecto.Query, only: [from: 2]

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

  @spec get_messages(integer, boolean, boolean) :: Map
  def get_messages(session_topic_id, filter_star, include_facilitator) do
    query =
      QueriesMessages.base_query(session_topic_id)
      |> QueriesMessages.filter_star(filter_star)
      |> QueriesMessages.join_session_member()

    if !include_facilitator, do: query = QueriesMessages.exclude_by_role(query, "facilitator")
    query = QueriesMessages.sort_select(query)

    Repo.all(query)
  end

  @spec get_session_and_topic_names(integer) :: {String.t, String.t}
  def get_session_and_topic_names(session_topic_id) do
  %{name: session_topic_name, session: %{name: session_name}} =
    Repo.one(
      from session_topic in SessionTopic,
      where: session_topic.id == ^session_topic_id,
      preload: [:session]
    )
  {session_name, session_topic_name}
  end
end
