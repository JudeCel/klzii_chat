defmodule KlziiChat.Guardian.Serializer do
  @behaviour Guardian.Serializer

  alias KlziiChat.{Repo, SessionMember, AccountUser}

  def for_token(session_member = %SessionMember{}), do: { :ok, "SessionMember:#{session_member.id}" }
  def for_token(account_user = %AccountUser{}), do: { :ok, "AccountUser:#{account_user.id}" }
  def for_token(_), do: { :error, "Unknown resource type" }

  def from_token("SessionMember:" <> id) do
    if Regex.match?(~r/^[0-9]*$/, id) do
      member =
      Repo.get(SessionMember, String.to_integer(id))
      |> Repo.preload([account_user: [:account] ])
      { :ok, %{account_user: member.account_user, session_member: member} }
    else
      { :error, "Unknown resource type" }
    end
  end

  def from_token("AccountUser:" <> id) do
    if Regex.match?(~r/^[0-9]*$/, id) do
      account_user =
      Repo.get(AccountUser, String.to_integer(id))
      |> Repo.preload([:account])
      { :ok, %{account_user: account_user, session_member: nil} }
    else
      { :error, "Unknown resource type" }
    end
  end

  def from_token(_), do: { :error, "Unknown resource type" }
end
