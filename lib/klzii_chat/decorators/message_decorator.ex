defmodule KlziiChat.Decorators.MessageDecorator do

  @emotion_names %{ 0 => "Smiling",
                    1 => "Happy",
                    2 => "Sad",
                    3 => "Angry",
                    4 => "Confused",
                    5 => "Loving",
                    6 => "Sleepy" }

  @spec votes_count(List.t) :: Integer.t
  def votes_count(votes) do
    Enum.count(votes)
  end

  @spec has_voted(List.t, Integer.t) :: Boolean.t
  def has_voted(votes, session_member_id) do
    Enum.any?(votes, &(&1.sessionMemberId == session_member_id))
  end

  @spec emotion_name(integer) :: String.t
  def emotion_name(emotion_id), do: Map.get(@emotion_names, emotion_id, :error)

end
