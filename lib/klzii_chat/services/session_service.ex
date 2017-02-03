defmodule KlziiChat.Services.SessionService do
  alias KlziiChat.{Repo, SessionView}
  alias KlziiChat.Queries.Sessions, as: SessionsQueries

  @spec error_messages() :: Map.t
  def error_messages() do
    %{
      session_not_found:  "Session not found"
    }
  end

  @spec find_active(Intiger.t) :: {:ok, Map.t} | {:error, String.t}
  def find_active(session_id) do
    SessionsQueries.find(session_id)
    |> Repo.one
    |> case  do
        nil ->
          {:error, error_messages().session_not_found}
        session ->
          {:ok, SessionView.render("session.json", %{session: session})}
       end
  end
end
