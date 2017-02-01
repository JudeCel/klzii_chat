defmodule KlziiChat.Services.Reports.Types.RecruiterSurvey.Statistic do

  @spec map_answers(List.t) :: Map.t
  def map_answers(list) do
    Enum.reduce(list, %{}, fn(sub_list, acc) ->
      Map.keys(sub_list)
      |> Enum.reduce(acc, fn(item, sub_list_acc) ->
        answer = Map.get(sub_list, item)
        acc_answers =
          Map.get(sub_list_acc, item, answer_default(answer))
          |> processed_answer(answer)

        Map.put(sub_list_acc, item, acc_answers)
      end)
    end)
  end

  @spec answer_default(Map.t) :: Map.t | List.t
  def answer_default(%{"type" => "string"}), do: %{count: 0, type: "string", values: []}
  def answer_default(%{"type" => "number"}), do: %{count: 0, type: "number", values: %{}}
  def answer_default(%{"type" => "object"}), do: %{count: 0, type: "object", values: %{}}
  def answer_default(_), do: nil



  def processed_answer(buffer, %{"type" => "number", "value" => value_nr}) do
    values = buffer.values
    buffer_value = Map.get(values, value_nr, 0)
    update_values = Map.put(values, value_nr, buffer_value + 1)
    Map.put(buffer, :count, buffer.count + 1)
    |> Map.put(:values, update_values)
  end
  def processed_answer(buffer, %{"type" => "string", "value" => value}) do
    values = buffer.values
    Map.put(buffer, :values, (values ++ [value]))
    |> Map.put(:count, buffer.count + 1)
  end
  def processed_answer(buffer, %{"type" => "object", "contactDetails" => contactDetails}) do
    IO.inspect contactDetails
    buffer
  end
  def processed_answer(buffer, _) do
    buffer
  end
end
