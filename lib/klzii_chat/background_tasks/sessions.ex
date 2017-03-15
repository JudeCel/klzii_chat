defmodule KlziiChat.BackgroundTasks.Sessions do
  alias KlziiChat.Services.{SessionService}
  alias KlziiChat.{Endpoint}

  def perform(id, type) do
    case type do
      "DELETE" ->
        Endpoint.broadcast!("sessionsBuilder:#{id}", "session_deleted", %{})
      _ ->
        update_session(id)
    end
  end

  def update_session(id) do
    case SessionService.find_active(id) do
      {:ok, session} ->
        Endpoint.broadcast!("sessions:#{session.id}", "update_session", session)
      {:error, reason} ->
       {:error, %{reason: reason}}
    end
  end
end
