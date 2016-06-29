defmodule KlziiChat.Decorators.MiniSurveyAnswersDecorator do
  @yes_no_maybe %{1 => "Yes", 2 => "No", 3 => "Maybe"}
  @star_rating %{1 => "1 star", 2 => "2 stars", 3 => "3 stars", 4 => "4 stars", 5 => "5 stars"}

  @spec answer_text(String.t, String.t) :: {:ok | :error, String.t}
  def answer_text(type, answer_id) when is_bitstring(answer_id) do
    case Integer.parse(answer_id) do
      {answer_id_int, ""} -> answer_text(type, answer_id_int)
       _ -> {:error, "incorrect answer id"}
    end
  end

  @spec answer_text(String.t, integer) :: {:ok | :error, String.t}
  def answer_text("yesNoMaybe", answer_id_int) when is_integer(answer_id_int) do
     case Map.get(@yes_no_maybe, answer_id_int) do
       nil -> {:error, "incorrect answer id"}
       answ_text -> {:ok, answ_text}
     end
  end

  @spec answer_text(String.t, integer) :: {:ok | :error, String.t}
  def answer_text("5starRating", answer_id_int) when is_integer(answer_id_int) do
     case Map.get(@star_rating, answer_id_int) do
       nil -> {:error, "incorrect answer id"}
       answ_text -> {:ok, answ_text}
     end
  end
end
