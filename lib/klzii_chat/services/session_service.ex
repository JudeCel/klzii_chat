defmodule KlziiChat.Services.SessionService do
  alias KlziiChat.{Repo, Session, SessionView}

  def find(session_id) do
    case Repo.get_by(Session, id: session_id) do
      nil ->
        nil
      session ->
      preload_session =
        session
          |> Repo.preload([:session_members, :topics])
      {:ok, Phoenix.View.render(SessionView, "session.json", %{session: preload_session})}
    end
  end
end
