defmodule KlziiChat.Guardian.Serializer do
  @behaviour Guardian.Serializer

  alias KlziiChat.{Repo, SessionMember, AccountUser}

  def for_token(session_member = %SessionMember{}), do: { :ok, "SessionMember:#{session_member.id}" }
  def for_token(account_user = %AccountUser{}), do: { :ok, "AccountUser:#{account_user.id}" }
  def for_token(_), do: { :error, "Unknown resource type" }

  def from_token("SessionMember:" <> id) do
    member =
      Repo.get(SessionMember, String.to_integer(id))
        |> Repo.preload([account_user: [:account] ])
     { :ok, member }
  end
  def from_token("AccountUser:" <> id), do: { :ok, Repo.get(AccountUser, String.to_integer(id)) }
  def from_token(_), do: { :error, "Unknown resource type" }
end
