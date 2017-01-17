defmodule KlziiChat.BackgroundTasks.Sessions do
  alias KlziiChat.Services.{SessionService}
  alias KlziiChat.{Endpoint}

  def perform(id, _type) do
    update_session(id)
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