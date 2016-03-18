defmodule KlziiChat.GuardianSerializer do
  @behaviour Guardian.Serializer

  alias KlziiChat.{Repo, SessionMember}

  def for_token(session_member = %SessionMember{}), do: { :ok, "SessionMember:#{session_member.id}" }
  def for_token(_), do: { :error, "Unknown resource type" }

  def from_token("User:" <> id), do: { :ok, Repo.get(SessionMember, String.to_integer(id)) }
  def from_token(_), do: { :error, "Unknown resource type" }
end
