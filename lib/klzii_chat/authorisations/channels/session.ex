defmodule KlziiChat.Authorisations.Channels.Session do

  @spec authorized?(%Phoenix.Socket{}, Integer.t) :: {:ok} | {:error, String.t}
  def authorized?(socket, sesssion_id) do
    validate(socket.assigns.session_member, sesssion_id)
  end

  @spec validate(Map.t, Integer.t) :: {:ok} | {:error, String.t}
  def validate(session_member, sesssion_id) do
    with {:ok} <- valid_session_for_session_member(session_member, sesssion_id),
         {:ok} <- is_subscription_preferencen(session_member.permissions),
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

  @spec is_subscription_preferencen(map) :: {:ok} | {:error, String.t}
  defp is_subscription_preferencen(preference) when is_map(preference), do: {:ok}
  defp is_subscription_preferencen(_), do: {:error, error_messages.subscription_not_found}
end
