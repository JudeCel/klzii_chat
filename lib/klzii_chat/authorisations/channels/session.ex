defmodule KlziiChat.Authorisations.Channels.Session do
  alias KlziiChat.{Repo}
  alias KlziiChat.Queries.Sessions, as: SessionQueries

  @spec authorized?(%Phoenix.Socket{}, Integer.t) :: {:ok} | {:error, String.t}
  def authorized?(socket, sesssion_id) do
    validate(socket.assigns.session_member, sesssion_id)
  end

  @spec validate(Map.t, Integer.t) :: {:ok} | {:error, String.t}
  def validate(session_member, sesssion_id) do
    with {:ok} <- valid_session_for_session_member(session_member, sesssion_id),
         {:ok} <- get_subscription_preference_session(sesssion_id),
    do: {:ok}
  end

  @spec valid_session_for_session_member(Map.t, Integer.t) :: {:ok} | {:error, String.t}
  def valid_session_for_session_member(session_member, sesssion_id) do
    if session_member.session_id == sesssion_id do
      {:ok}
    else
      {:error, error_messages.dont_have_access}
    end
  end

  @spec error_messages() :: Map.t
  def error_messages do
    %{
      dont_have_access: "You don't have access this session",
      subscription_not_found: "Subscription not found"
    }
  end

  @spec get_subscription_preference_session(Integer.t) :: {:ok} | {:error, String.t}
  defp get_subscription_preference_session(session_id) do
    SessionQueries.get_subscription_preference_session(session_id)
      |> Repo.one
      |> case do
        nil ->
          {:error, error_messages.subscription_not_found}
        _ ->
          {:ok}
      end
  end
end
