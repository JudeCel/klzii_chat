defmodule KlziiChat.Decorators.MessageDecorator do

  @emotion_names %{ 0 => "normal",
                    1 => "smiling",
                    2 => "sad",
                    3 => "angry",
                    4 => "confused",
                    5 => "loving",
                    6 => "sleepy" }

  @spec votes_count(List.t) :: Integer.t
  def votes_count(votes) do
    Enum.count(votes)
  end

  @spec has_voted(List.t, Integer.t) :: Boolean.t
  def has_voted(votes, session_member_id) do
    Enum.any?(votes, &(&1.sessionMemberId == session_member_id))
  end

  @spec emotion_name(integer) :: String.t
  def emotion_name(emotion_id) when is_integer(emotion_id), do: Map.get(@emotion_names, emotion_id, :error)

end
