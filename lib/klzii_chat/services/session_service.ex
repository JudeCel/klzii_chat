defmodule KlziiChat.Services.SessionService do
  alias KlziiChat.{Repo, SessionView}
  alias KlziiChat.Queries.Sessions, as: SessionsQueries
  def find(session_id) do
    SessionsQueries.find(session_id)
    |> Repo.one
    |> case  do
        nil ->
          {:error, "Session not found"}
        session ->
          {:ok, Phoenix.View.render(SessionView, "session.json", %{session: session})}
       end
  end
end
