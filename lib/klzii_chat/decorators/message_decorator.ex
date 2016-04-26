defmodule KlziiChat.Decorators.MessageDecorator do

  @spec votes_count(List.t) :: Integer.t
  def votes_count(votes) do
    Enum.count(votes)
  end

  @spec has_voted(List.t, Integer.t) :: Boolean.t
  def has_voted(votes, session_member_id) do
    Enum.any?(votes, &(&1.sessionMemberId == session_member_id))
  end
end
