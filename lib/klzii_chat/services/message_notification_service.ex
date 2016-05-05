defmodule KlziiChat.Services.MessageNotificationService do
  alias KlziiChat.{Repo, Message, Session, OfflineMessage, Endpoint, Presence}
  import Ecto
  import Ecto.Query, only: [from: 1, from: 2]

  def run(session_id, session_member_id, topic_id, message_id) do
    current_topic_presences = Presence.list("topics:#{topic_id}") |> Map.keys
    current_session_presences = Presence.list("sessions:#{session_id}") |> Map.keys

    session = Repo.get_by!(Session, id: session_id)
    message = Repo.get_by!(Message, id: message_id) |> Repo.preload([:reply])

    session_member_ids =
      from(sm in assoc(session, :session_members), where: sm.id != ^session_member_id, select: sm.id)
      |> Repo.all
    topic_ids =
      from(t in assoc(session, :topics), where: t.id != ^topic_id, select: t.id)
      |> Repo.all

    online_unread_members_ids = List.foldl(current_topic_presences, session_member_ids, fn (id, acc) ->
      acc = List.delete(acc, id)
    end)

    offline_messages = Enum.map(session_member_ids, fn id ->
      scope = case message.reply do
        %{sessionMemberId: ^id} ->
          "replay"
        nil ->
          "normal"
      end
      [scope: scope, topicId: topic_id, sessionMemberId: id, messageId: message_id, createdAt: Timex.DateTime.now, updatedAt: Timex.DateTime.now]
    end)

    Repo.insert_all(OfflineMessage, offline_messages)
    data =
      from(om in OfflineMessage,
        where: om.sessionMemberId in ^online_unread_members_ids,
        group_by: [:sessionMemberId, :topicId, :scope],
        select: %{om.sessionMemberId => %{ om.topicId => %{om.scope =>  count(om.id)} } })
      |> Repo.all |> List.first

    Endpoint.broadcast!( "sessions:#{session_id}", "unread_messages", data)
  end

  def notify do

  end
end
