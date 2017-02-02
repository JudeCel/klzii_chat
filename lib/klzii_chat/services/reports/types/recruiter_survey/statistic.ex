defmodule KlziiChat.Services.Reports.Types.RecruiterSurvey.Statistic do
  @countable_contact_list_fields  ["age", "gender"]


  def map_question_list_answers(list, answer_map) do
    Enum.reduce(list, [], fn(question, acc) ->
      update_answers =
        Map.get(answer_map, to_string(question.id))
        |> processed_question_answers(question.answers)

      acc ++ [Map.put(question, :answers, update_answers)]
      # |> IO.inspect
    end)
  end

  def processed_question_answers(qestion_statistic, answers) do
    Enum.reduce(answers, [], fn(answer, acc) ->
      acc ++ [processed_qestion_answer(qestion_statistic, answer)]
    end )
  end

  def processed_qestion_answer(qestion_statistic, %{"name" => name, "order" => order}) do
    count =
      Map.get(qestion_statistic, :values)
      |> Map.get(order, 0)
      percents =  calculate_statistic_percents(count, qestion_statistic.count)
    %{name: name, count: count, percents: percents}
  end
  def processed_qestion_answer(qestion_statistic, _) do
    count =
      Map.get(qestion_statistic, :values)
      |> Enum.count
      percents =  calculate_statistic_percents(count, qestion_statistic.count)

    %{count: count, percents: percents, valuse: qestion_statistic.values}
  end

  def calculate_statistic_percents(count, total_count) do
      percents = (100 * count / total_count) |> Float.round
  end

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

  @spec answer_default(Map.t) :: Map.t
  def answer_default(%{"type" => "string"}), do: %{count: 0, type: "string"}
  def answer_default(%{"type" => "number"}), do: %{count: 0, type: "number"}
  def answer_default(%{"type" => "object"}), do: %{count: 0, type: "object"}
  def answer_default(_), do: %{count: 0}

  @spec processed_answer(Map.t, Map.t) :: Map.t
  def processed_answer(buffer, %{"type" => "number", "value" => value_nr}) do
    values = Map.get(buffer, :values, %{})
    buffer_value = Map.get(values, value_nr, 0)
    update_values = Map.put(values, value_nr, buffer_value + 1)
    Map.put(buffer, :count, buffer.count + 1)
    |> Map.put(:values, update_values)
  end
  def processed_answer(buffer, %{"type" => "string", "value" => value}) do
    values = Map.get(buffer, :values, [])
    Map.put(buffer, :values, (values ++ [value]))
    |> update_answer_count()
  end
  def processed_answer(buffer, %{"type" => "object", "contactDetails" => contactDetails}) do
    values = Map.get(buffer, :values, %{})

    update_values =
      @countable_contact_list_fields
      |> Enum.reduce(values, fn(key, acc) ->
        contactDetailsValue = Map.get(contactDetails, key)
        buffer_value = Map.get(acc, key, %{})
        field_value = Map.get(buffer_value, contactDetailsValue, 0)
        new_val = Map.put(buffer_value, contactDetailsValue, field_value + 1)
        Map.put(acc, key, new_val)

      end)
    Map.put(buffer, :type, "object")
    |> Map.put(:values, update_values)
    |> update_answer_count()
  end
  def processed_answer(buffer, _) do
    update_answer_count(buffer)
  end

  @spec update_answer_count(Map.t) :: Map.t
  def update_answer_count(buffer) do
    Map.put(buffer, :count, buffer.count + 1)
  end
end
