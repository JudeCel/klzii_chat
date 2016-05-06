defmodule KlziiChat.Services.MessageNotificationService do
  alias KlziiChat.{Repo, Message, SessionMember, OfflineMessage, Endpoint, Presence}
  import Ecto.Query, only: [from: 1, from: 2]

  def run(session_id, _session_member_id, topic_id, message_id) do
    current_topic_presences = topic_presences(topic_id)
    current_session_presences = session_presences(session_id)

    message = get_message(message_id)

    # get all session members for specifice session
    all_session_member_ids = get_all_session_members(session_id)

    # get all members who not connected to specific topic.
    unread_members_ids = find_diff(current_topic_presences, all_session_member_ids)

    # Create unread messages for session members
    insert_offline_records(unread_members_ids, message)

    # find conected session member ids for notification
    notifiable_session_member_ids = find_diff(current_topic_presences, current_session_presences)

    # get data for notifications
    data = get_unread_messages(notifiable_session_member_ids)

    #notify members
    notify(session_id, data)
  end

  def get_unread_messages(session_member_ids) do
    from(om in OfflineMessage,
      where: om.sessionMemberId in ^session_member_ids,
      group_by: [:topicId, :scope, :sessionMemberId],
      select: %{"id" => om.sessionMemberId, "topic" => %{om.topicId => %{om.scope => count(om.scope)}}})
    |> Repo.all |> group_by_topics_and_scope |> calculate_summary
  end

  def calculate_summary(map) do
    Map.keys(map) |> List.foldl(map, fn id, accumulator ->
      topics = accumulator[id]["topics"]
      Map.keys(topics)
        |> Enum.reduce(accumulator, fn (key, acc) ->
          topic = topics[key]
          normal = topic["normal"] || 0
          replay = topic["replay"] || 0
          acc = update_in(acc[id]["summary"]["normal"], fn k -> k + normal end)
          update_in(acc[id]["summary"]["replay"], fn k -> k + replay end)
      end)
    end)
  end

  def group_by_topics_and_scope(list) do
    List.foldl(list, %{}, fn(item, acc) ->
      id = Map.get(item, "id") |> to_string
      topic = Map.get(item, "topic")
      new_acc = Map.put_new(acc, id, %{"topics" => %{}, "summary" => %{"normal" => 0, "replay" => 0 }})

      update_in(new_acc[id]["topics"], fn val ->
        key = Map.keys(topic)|> List.first
        string_key = to_string(key)
        value = Map.get(val, string_key, %{})
        scope = Map.get(topic, key)
        new_value = Map.merge(value, scope)
        Map.put(val, string_key, new_value)
      end)
    end)
  end

  def insert_offline_records(session_member_ids, message) do
    offline_messages = Enum.map(session_member_ids, fn id ->
      scope = case message.reply do
        %Message{sessionMemberId: ^id} ->
          "replay"
        _ ->
          "normal"
      end
      [scope: scope, topicId: message.topicId, sessionMemberId: id, messageId: message.id, createdAt: Timex.DateTime.now, updatedAt: Timex.DateTime.now]
    end)

    Repo.insert_all(OfflineMessage, offline_messages)
  end

  def get_message(message_id) do
    Repo.get_by!(Message, id: message_id) |> Repo.preload([:reply])
  end

  def find_diff(first, second) do
    List.foldl(first, second, fn (id, acc) ->
      List.delete(acc, id)
    end)
  end

  def delete_unread_messages_for_topic(session_mmeber_id, topic_id) do
    from(om in OfflineMessage, where: om.sessionMemberId == ^session_mmeber_id,  where: om.topicId == ^topic_id)
      |> Repo.delete_all
  end

  def get_all_session_members(session_id) do
    roles = ["facilitator", "participant"]
    from(sm in SessionMember, where: sm.sessionId == ^session_id, where: sm.role in ^roles, select: sm.id)
      |> Repo.all
  end

  def notify(session_id, data) do
    Endpoint.broadcast!( "sessions:#{session_id}", "unread_messages", data)
  end

  def topic_presences(topic_id) do
    Presence.list("topics:#{topic_id}") |> Map.keys
  end

  def session_presences(session_id) do
    Presence.list("sessions:#{session_id}") |> Map.keys
  end
end
