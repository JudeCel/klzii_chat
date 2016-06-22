defmodule KlziiChat.Services.SessionTopicService do
  alias KlziiChat.{Repo, SessionMember, SessionTopic}
  alias KlziiChat.Services.Permissions.SessionTopic, as: SessionTopicPermissions

  def errors_messages do
    %{
      action_not_allowed:  "Action not allowed!"
    }
  end

  @spec board_message(Integer, Integer, Map) :: {:ok, Map } | {:error, String.t}
  def board_message(session_member_id, session_topic_id, %{"message" => message}) do
    session_member = Repo.get!(SessionMember, session_member_id)
    session_topic = Repo.get!(SessionTopic, session_topic_id)
    if SessionTopicPermissions.can_board_message(session_member) do
      Ecto.Changeset.change(session_topic, boardMessage: message) |> Repo.update
    else
      {:error, errors_messages.action_not_allowed}
    end
  end
end
