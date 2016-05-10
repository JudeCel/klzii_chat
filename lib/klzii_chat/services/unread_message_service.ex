defmodule KlziiChat.Services.UnreadMessageService do
  alias KlziiChat.{Repo, Message, SessionMember, UnreadMessage, Endpoint, Presence}
  import Ecto.Query, only: [from: 1, from: 2]

  @default_summary %{"summary" => %{"normal" => 0, "reply" => 0 }}

  @spec process_delete_message(Integer.t, Integer.t) :: :ok
  def process_delete_message(session_id, topic_id) do
    current_topic_presences_ids = topic_presences_ids(topic_id)
    current_session_presences_ids = session_presences_ids(session_id)

    diff = find_diff(current_topic_presences_ids, current_session_presences_ids)
    data = get_unread_messages(diff) |> group_by_topics_and_scope |> calculate_summary
    notify(session_id, data)
  end

  @spec sync_state(Integer.t) :: Map.t
  def sync_state(session_member_id) do
    id = "#{session_member_id}"
    get_unread_messages([session_member_id])
      |> group_by_topics_and_scope
      |> calculate_summary
      |> case do
          messages  when messages == %{} ->
            %{id =>  Map.merge(%{"topics" => %{}}, @default_summary)}
          messages->
            messages
        end
  end

  @spec delete_message(Integer.t) :: :ok
  def delete_message(message_id) do
    from(om in UnreadMessage, where: om.messageId == ^message_id)|> Repo.delete_all
  end

  @spec process_new_message(Integer.t, Integer.t, Integer.t) :: :ok | nil
  def process_new_message(session_id, topic_id, message_id) do
    case Mix.env do
      :test ->
        new_message(session_id, topic_id, message_id)
      _->
        Task.start(fn ->
          new_message(session_id, topic_id, message_id)
        end)
    end
    :ok
  end

  @spec new_message(Integer.t, Integer.t, Integer.t) :: :ok
  def new_message(session_id, topic_id, message_id) do
    current_topic_presences_ids = topic_presences_ids(topic_id)
    current_session_presences_ids = session_presences_ids(session_id)

    message = get_message(message_id)

    # get all session members for specifice session
    all_session_member_ids = get_all_session_members(session_id)

    # get all members who not connected to specific topic.
    unread_members_ids = find_diff(current_topic_presences_ids, all_session_member_ids)

    # Create unread messages for session members
    insert_offline_records(unread_members_ids, message)

    # find conected session member ids for notification
    notifiable_session_member_ids = find_diff(current_topic_presences_ids, current_session_presences_ids)

    # get data for notifications
    data = get_unread_messages(notifiable_session_member_ids) |> group_by_topics_and_scope |> calculate_summary

    #notify members
    notify(session_id, data)
  end

  @spec get_unread_messages([String.t,...]) :: Map.t
  def get_unread_messages(session_member_ids) do
    from(sm in SessionMember,
      where: sm.id in ^session_member_ids,
      left_join: um in UnreadMessage, on: sm.id == um.sessionMemberId,
      group_by: [sm.id, um.scope, um.topicId],
      select: %{"id" => sm.id, "topic" => {um.topicId, %{um.scope => count(um.scope)}}}
    )|> Repo.all
  end

  @spec calculate_summary(Map.t) :: Map.t
  def calculate_summary(map) do
    Map.keys(map) |> List.foldl(map, fn id, accumulator ->
      topics = accumulator[id]["topics"]
      accumulator = Map.put(accumulator, id, Map.merge(accumulator[id], @default_summary))
      Map.keys(topics)
        |> Enum.reduce(accumulator, fn (key, acc) ->
          topic = topics[key]
          normal = topic["normal"] || 0
          reply = topic["reply"] || 0
          acc = update_in(acc[id]["summary"]["normal"], fn k -> k + normal end)
          update_in(acc[id]["summary"]["reply"], fn k -> k + reply end)
      end)
    end)
  end

  @spec group_by_topics_and_scope(List.t) :: Map.t
  def group_by_topics_and_scope(list) do
    default_map = %{"topics" => %{}}

    List.foldl(list, %{}, fn(item, acc) ->
      id = Map.get(item, "id") |> to_string
      new_acc = Map.put_new(acc, id, default_map)
      topic = Map.get(item, "topic")
      update_in(new_acc[id]["topics"], fn val ->
        update_topic_map(topic, val)
      end)

    end)
  end

  def update_topic_map({nil, _}, val), do: val
  def update_topic_map({id, scope}, val) do
    string_key = to_string(id)
    value = Map.get(val, string_key, %{})
    new_value = Map.merge(value, scope)
    Map.put(val, string_key, new_value)
  end
  def update_topic_map(_, val), do: val

  @spec insert_offline_records(List.t, %Message{}) :: {Iinteger.t, nil | [term]}
  def insert_offline_records(session_member_ids, message) do
    offline_messages = Enum.map(session_member_ids, fn id ->
      scope = case message.reply do
        %Message{sessionMemberId: ^id} ->
          UnreadMessage.scopes.reply
        _ ->
          UnreadMessage.scopes.normal
      end
      [scope: scope, topicId: message.topicId, sessionMemberId: id, messageId: message.id, createdAt: Timex.DateTime.now, updatedAt: Timex.DateTime.now]
    end)

    Repo.insert_all(UnreadMessage, offline_messages)
  end

  @spec get_message(Integer.t) :: %Message{}
  def get_message(message_id) do
    Repo.get_by!(Message, id: message_id) |> Repo.preload([:reply])
  end

  @spec find_diff(List.t, List.t) :: List.t
  def find_diff(first, second) do
    List.foldl(first, second, fn (id, acc) ->
      result = List.delete(acc, id)
      if result == acc do
        result ++ [id]
      else
        result
      end
    end)
  end

  @spec delete_unread_messages_for_topic(String.t, String.t) :: {Integer.t, nil | [term]}
  def delete_unread_messages_for_topic(session_mmeber_id, topic_id) do
    from(om in UnreadMessage, where: om.sessionMemberId == ^session_mmeber_id,  where: om.topicId == ^topic_id)
      |> Repo.delete_all
  end

  @spec get_all_session_members(Integer.t) :: List.t
  def get_all_session_members(session_id) do
    roles = ["facilitator", "participant"]
    from(sm in SessionMember, where: sm.sessionId == ^session_id, where: sm.role in ^roles, select: sm.id)
      |> Repo.all
  end

  @spec notify(String.t, Map.t) :: :ok
  def notify(session_id, data) do
    Endpoint.broadcast!( "sessions:#{session_id}", "unread_messages", data)
  end

  @spec topic_presences_ids(String.t) :: List.t
  def topic_presences_ids(topic_id) do
    Presence.list("topics:#{topic_id}") |> Map.keys |> Enum.map(&(String.to_integer(&1)))
  end

  @spec session_presences_ids(String.t) :: List.t
  def session_presences_ids(session_id) do
    Presence.list("sessions:#{session_id}") |> Map.keys |> Enum.map(&(String.to_integer(&1)))
  end
end
