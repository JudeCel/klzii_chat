defmodule KlziiChat.Decorators.MessageDecorator do

  @emotion_names %{ 0 => "sad",
                    1 => "angry",
                    2 => "confused",
                    3 => "smiling",
                    4 => "loving",
                    5 => "normal",
                    6 => "sleepy" }

  @spec votes_count(List.t) :: Integer.t
  def votes_count(votes) do
    Enum.count(votes)
  end

  @spec has_voted(List.t, Integer.t) :: Boolean.t
  def has_voted(votes, session_member_id) do
    Enum.any?(votes, &(&1.sessionMemberId == session_member_id))
  end

  @spec emotion_name(integer) :: {:ok | :error, String.t}
  def emotion_name(emotion_id) when is_integer(emotion_id) do
    case Map.get(@emotion_names, emotion_id) do
      nil -> {:error, "incorrect emotion id"}
      em_name -> {:ok, em_name}
    end
  end

  @spec emotion_name(String.t) :: {:ok | :error, String.t}
  def emotion_name(emotion_id) when is_bitstring(emotion_id) do
    case Integer.parse(emotion_id) do
      {emotion_num_id, ""} -> emotion_name(emotion_num_id)
      _ -> {:error, "incorrect emotion id"}
    end
  end
end
