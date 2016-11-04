defmodule KlziiChat.Services.UnreadMessageService do
  alias KlziiChat.{Repo, Message, SessionMember, UnreadMessage, SessionTopic, Endpoint}
  alias KlziiChat.Helpers.ListHelper
  import Ecto.Query, only: [from: 2]
  import KlziiChat.Helpers.Presence, only: [topic_presences_ids: 1, session_presences_ids: 1]

  @default_summary %{"summary" => %{"normal" => 0, "reply" => 0 }}

  @spec process_delete_message(Integer.t, Integer.t) :: :ok
  def process_delete_message(session_id, session_topic_id) do

    current_session_presences_ids = session_presences_ids(session_id)

    diff = ListHelper.find_diff(topic_presences_ids(session_topic_id), current_session_presences_ids)
    data = get_unread_messages(diff) |> group_by_session_topics_and_scope |> calculate_summary
    {:ok, session_id, data}
  end

  @spec sync_state(Integer.t) :: Map.t
  def sync_state(session_member_id) do
    id = "#{session_member_id}"
    get_unread_messages([session_member_id])
      |> group_by_session_topics_and_scope
      |> calculate_summary
      |> case do
          messages  when messages == %{} ->
            %{id =>  Map.merge(%{"session_topics" => %{}}, @default_summary)}
          messages->
            messages
        end
  end

  @spec delete_message(Integer.t) :: :ok
  def delete_message(message_id) do
    from(om in UnreadMessage, where: om.messageId == ^message_id)|> Repo.delete_all
  end

  @spec process_new_message(Integer.t) :: :ok | nil
  def process_new_message(message_id) do
    new_message(message_id)
  end

  @spec new_message(Integer.t) :: :ok
  def new_message(message_id) do
    message = get_message(message_id)
    session_id = message.session_topic.session.id
    session_topic = message.session_topic.id

    current_topic_presences_ids = topic_presences_ids(session_topic)
    current_session_presences_ids = session_presences_ids(session_id)

    # get all session members for specifice session
    all_session_member_ids = get_all_session_members(session_id)
    # get all members who not connected to specific topic.
    unread_members_ids = ListHelper.find_diff(current_topic_presences_ids, all_session_member_ids)
    # Create unread messages for session members
    insert_offline_records(unread_members_ids, message)
    # find conected session member ids for notification
    notifiable_session_member_ids = ListHelper.find_diff(current_topic_presences_ids, current_session_presences_ids)
    # get data for notifications
    data = get_unread_messages(notifiable_session_member_ids) |> group_by_session_topics_and_scope |> calculate_summary

    {:ok, session_id, data}
  end

  @spec get_unread_messages([String.t,...]) :: Map.t
  def get_unread_messages(session_member_ids) do
    from(sm in SessionMember,
      where: sm.id in ^session_member_ids,
      left_join: um in UnreadMessage, on: sm.id == um.sessionMemberId,
      join: st in SessionTopic, on: st.id == um.sessionTopicId and st.active == true,
      group_by: [sm.id, um.scope, um.sessionTopicId],
      select: %{"id" => sm.id, "session_topic" => {um.sessionTopicId, %{um.scope => count(um.scope)}}}
    )|> Repo.all
  end

  @spec calculate_summary(Map.t) :: Map.t
  def calculate_summary(map) do
    Map.keys(map) |> List.foldl(map, fn id, accumulator ->
      topics = accumulator[id]["session_topics"]
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

  @spec group_by_session_topics_and_scope(List.t) :: Map.t
  def group_by_session_topics_and_scope(list) do
    default_map = %{"session_topics" => %{}}

    List.foldl(list, %{}, fn(item, acc) ->
      id = Map.get(item, "id") |> to_string
      new_acc = Map.put_new(acc, id, default_map)
      topic = Map.get(item, "session_topic")
      update_in(new_acc[id]["session_topics"], fn val ->
        update_session_topic_map(topic, val)
      end)

    end)
  end

  def update_session_topic_map({nil, _}, val), do: val
  def update_session_topic_map({id, scope}, val) do
    string_key = to_string(id)
    value = Map.get(val, string_key, %{})
    new_value = Map.merge(value, scope)
    Map.put(val, string_key, new_value)
  end
  def update_session_topic_map(_, val), do: val

  @spec insert_offline_records(List.t, %Message{}) :: {Integer.t, nil | [term]}
  def insert_offline_records(session_member_ids, message) do
    offline_messages = Enum.map(session_member_ids, fn id ->
      scope = case message.reply do
        %Message{sessionMemberId: ^id} ->
          UnreadMessage.scopes.reply
        _ ->
          UnreadMessage.scopes.normal
      end
      [ scope: scope, sessionTopicId: message.sessionTopicId, sessionMemberId: id,
        messageId: message.id, createdAt: Timex.now, updatedAt: Timex.now ]
    end)

    Repo.insert_all(UnreadMessage, offline_messages)
  end

  @spec get_message(Integer.t) :: %Message{}
  def get_message(message_id) do
    Repo.get_by!(Message, id: message_id) |> Repo.preload([:reply, session_topic: [:session]])
  end

  @spec delete(Integer.t, Integer.t) :: :ok
  def delete(session_member_id, id) do
    from(um in UnreadMessage, where: um.sessionMemberId == ^session_member_id,  where: um.messageId == ^id)|> Repo.delete_all
  end

  @spec get_all_session_members(Integer.t) :: List.t
  def get_all_session_members(session_id) do
    roles = ["facilitator", "participant", "observer"]
    from(sm in SessionMember, where: sm.sessionId == ^session_id, where: sm.role in ^roles, select: sm.id)
      |> Repo.all
  end

  @spec marked_read(Integer.t, Integer.t) :: {:ok}
  def marked_read(session_member_id, session_topic_id) do
    messages = sync_state(session_member_id)
    Endpoint.broadcast!("session_topic:#{session_topic_id}", "read_message",  %{messages: messages, session_member_id: session_member_id})
    {:ok}
  end
end
