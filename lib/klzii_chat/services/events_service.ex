defmodule KlziiChat.Services.EventsService do
  alias KlziiChat.{Repo, Event, EventView, SessionMember, Vote, Topic}
  alias KlziiChat.Services.Permissions
  import Ecto
  import Ecto.Query

  @spec history(Integer.t, String.t, Map.t) :: {:ok, List.t }
  def history(topic_id, tag, session_member) do
    topic = Repo.get!(Topic, topic_id)
    events = Repo.all(
      from e in assoc(topic, :events),
        where: [tag: ^tag],
        where: is_nil(e.replyId),
        order_by: [asc: e.createdAt],
        limit: 200,
      preload: [:session_member, :votes, replies: [:replies, :session_member, :votes] ]
    )
    resp = Enum.map(events, fn event ->
      EventView.render("event.json", %{event: event, member: session_member})
    end)
    {:ok, resp}
  end

  @spec create_message(Map.t, Integer.t, Map.t) :: {:ok, Map.t }
  def create_message(session_member, topic_id, params) do
    if Permissions.can_new_message(session_member) do
      replyId =
        case params["replyId"] do
          nil ->
            nil
          id ->
            String.to_integer(id)
        end

      session_member = Repo.get!(SessionMember, session_member.id)
      build_assoc(
        session_member, :events,
        tag: "message",
        replyId: replyId,
        sessionId: session_member.sessionId,
        event: params,
        topicId: topic_id
      ) |> create
    else
      {:error, "Action not allowed!"}
    end
  end

  @spec deleteById(Map.t, Integer.t) :: {:ok, %{ id: Integer.t, replyId: Integer.t } } :: {:error, String.t}
  def deleteById(session_member, id) do
    result = Repo.get_by!(Event, id: id)
    if Permissions.can_delete(session_member, result) do
      case Repo.delete!(result) do
        {:error, error} -> # Something went wrong
          {:error, error}
        event   -> # Deleted with success
          {:ok, %{ id: event.id, replyId: event.replyId } }
      end
    else
      {:error, "Action not allowed!"}
    end
  end

  @spec preload_dependencies(%Event{}) :: %Event{}
  def preload_dependencies(event) do
    Repo.preload(event, [:session_member, :votes, replies: [:replies, :session_member, :votes] ])
  end

  @spec create(%Event{}) :: %Event{}
  def create(changeset) do
    case Repo.insert(changeset) do
      {:ok, event} ->
        {:ok, preload_dependencies(event)}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @spec update_message(Integer.t, String.t, Map.t) :: %Event{} :: {:error, String.t}
  def update_message(id, body, session_member) do
    event = Repo.get_by!(Event, id: id)
    if Permissions.can_edit(session_member, event) do
      Ecto.Changeset.change(event, event: %{ body: body })
        |> update_msg
    else
      {:error, "Action not allowed!"}
    end
  end

  @spec update_msg(%Event{}) :: %Event{}
  def update_msg(changeset) do
    case Repo.update(changeset) do
      {:ok, event} ->
        {:ok, preload_dependencies(event)}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @spec star(Integer.t, Map.t) :: %Event{} :: {:error, String.t}
  def star(id, session_member) do
    if Permissions.can_star(session_member) do
      event = Repo.get_by!(Event, id: id)
      Ecto.Changeset.change(event, star: !event.star)
        |> update_msg
    else
      {:error, "Action not allowed!"}
    end
  end

  @spec thumbs_up(Integer.t, Map.t) :: Map.t :: {:error, String.t}
  def thumbs_up(id, session_member) do
    if Permissions.can_vote(session_member) do
      event = Repo.get_by!(Event, id: id)
      case Repo.get_by(Vote, eventId: id, sessionMemberId: session_member.id) do
        nil ->
          changeset = Vote.changeset(%Vote{}, %{sessionMemberId: session_member.id, eventId: id})
          case Repo.insert(changeset) do
            {:ok, _vote} ->
              {:ok, preload_dependencies(event)}
            {:error, changeset} ->
              {:error, changeset}
          end
        vote ->
          case Repo.delete!(vote) do
            {:error, changeset} ->
              {:error, changeset}
            _ ->
              {:ok, preload_dependencies(event)}
          end
      end
    else
      {:error, "Action not allowed!"}
    end
  end
end
