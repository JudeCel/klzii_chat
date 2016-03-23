defmodule KlziiChat.Services.SessionService do
  alias KlziiChat.{Repo, Session, SessionMember, SessionView}
  import Ecto
  import Ecto.Query, only: [from: 1, from: 2]

  def find(session_id) do
    case Repo.get_by!(Session, id: session_id) do
      nil ->
        nil
      session ->
      preload_session =
        session
          |> Repo.preload([:topics, :brand_project_preference])
      {:ok, Phoenix.View.render(SessionView, "session.json", %{session: preload_session})}
    end
  end
end
