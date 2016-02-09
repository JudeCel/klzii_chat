defmodule KlziiChat.Services.EventsService do
  alias KlziiChat.{Repo, EventView, SessionMember}
  import Ecto

  def create_message(session_member_id, params) do
    session_member = Repo.get!(SessionMember, session_member_id)
    changeset = build_assoc(
      session_member, :events,
      tag: "message",
      sessionId: session_member.sessionId,
      event: params,
      topicId: 1
    )
    create(changeset)
  end

  def create_object(session_member_id, params) do
    session_member = Repo.get!(SessionMember, session_member_id)
    changeset = build_assoc(
      session_member, :events,
      tag: "object",
      sessionId: session_member.sessionId,
      event: params,
      uid: params["id"],
      topicId: 1
    )
    create(changeset)
  end

  def create(changeset) do
    case Repo.insert(changeset) do
      {:ok, event} ->
        event = event |> Repo.preload(:session_member)
        {:ok, Phoenix.View.render(EventView, "event.json", %{event: event} )}
      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
