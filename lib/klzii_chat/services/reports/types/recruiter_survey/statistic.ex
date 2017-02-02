defmodule KlziiChat.Services.Reports.Types.RecruiterSurvey.Statistic do
  @countable_contact_list_fields  ["age", "gender"]

  def map_question_list_answers(list, answer_map) do
    questions = build_qestions(list)
    Enum.reduce(questions, [], fn(question, acc) ->
      update_answers =
        Map.get(answer_map, to_string(question.id))
        |> map_question_answers_with_stats(question)

      acc ++ [Map.put(question, :answers, update_answers)]
    end)
  end

  def build_qestions(list) do
    {:ok, questions_buffer} = Agent.start_link(fn -> [] end)
    Enum.each(list, fn(question) ->
      Enum.map(question.answers, fn(answer) ->
        processed_question_answers(answer, questions_buffer, %{id: question.id})
      end)
      |> Enum.filter(&(&1 != :skip))
      |> case do
        [] ->
          :ok
        answers ->
          new_question = Map.put(question, :answers, answers)
          Agent.update(questions_buffer, &(&1 ++ [new_question]))
        end
    end)
    Agent.get(questions_buffer, &(&1))
  end

  def processed_question_answers(%{"contactDetails" => contactDetails} = answer, questions_buffer, %{id: id}) do
    questions =
      Enum.map(@countable_contact_list_fields, fn(key) ->
      answer_model =
        Map.get(contactDetails, key)

      new_question = %{
        id: id,
        question: answer_model["name"],
        model: answer_model["model"]
      }
      answers =
        Enum.map(answer_model["options"], fn(option) ->
          %{name: option, type: "number", count: 0, percents: 0}
        end)
      Map.put(new_question, :answers, answers)
    end)
    Agent.update(questions_buffer, &(&1 ++ questions))
    :skip
  end
  def processed_question_answers(%{"name" => name, "order" => order}, _, _) do
    %{name: name, type: "number", count: 0, percents: 0, order: order}
  end
  def processed_question_answers(%{"order" => order}, _, _) do
    %{order: order, count: 0, type: "list", values: []}
  end
  def processed_question_answers(%{}, _, _), do: :skip


  @doc """
    Map with cliemt answers
  """

  def map_question_answers_with_stats(qestion_statistic, %{answers: answers} = question) do
    Enum.map(answers, fn(answe) ->
      map_question_answer(answe, qestion_statistic)
    end)
  end

  def map_question_answer(%{type: "number"} = answe , qestion_statistic) do
    qestion_statistic_values = Map.get(qestion_statistic, :values)
    qestion_statistic_count = Map.get(qestion_statistic, :count)
    order = Map.get(answe, :order)
    answer_value = Map.get(qestion_statistic_values, order, 0)
    percents =  calculate_statistic_percents(answer_value, qestion_statistic_count)
    Map.put(answe, :count, answer_value)
    |> Map.put(:percents, percents)
  end
  def map_question_answer(%{type: "list"} = answe , qestion_statistic) do
    qestion_statistic_values = Map.get(qestion_statistic, :values)
    qestion_statistic_count = Map.get(qestion_statistic, :count)
    count = Enum.count(qestion_statistic_values)
    percents = calculate_statistic_percents(count, qestion_statistic_count)
    Map.put(answe, :values, qestion_statistic_values)
    |> Map.put(:count, count)
    |> Map.put(:percents, percents)
  end

  def calculate_statistic_percents(count, total_count) do
    percents = (100 * count / total_count) |> Float.round
  end


  @doc """
    Prepare answers from client
  """

  @spec map_answers(List.t) :: Map.t
  def map_answers(list) do
    Enum.reduce(list, %{}, fn(question, acc) ->
      Map.keys(question)
      |> Enum.reduce(acc, fn(item, sub_list_acc) ->
        answer = Map.get(question, item)

        acc_answers =
          Map.get(sub_list_acc, item, answer)
          |> processed_answer(answer)
          |> Map.take([:name, :values, :count])

        Map.put(sub_list_acc, item, acc_answers)
      end)
    end)
  end

  @spec processed_answer(Map.t, Map.t) :: Map.t
  def processed_answer(buffer, %{"type" => "number", "value" => value_nr}) do
    values = Map.get(buffer, :values, %{})
    buffer_value = Map.get(values, value_nr, 0)
    update_values = Map.put(values, value_nr, buffer_value + 1)
    count = Map.get(buffer, :count, 0)
    Map.put(buffer, :count, count + 1)
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
    Map.put(buffer, :values, update_values)
    |> update_answer_count()
  end
  def processed_answer(buffer, _) do
    update_answer_count(buffer)
  end

  @spec update_answer_count(Map.t) :: Map.t
  def update_answer_count(buffer) do
    count = Map.get(buffer, :count, 0)
    Map.put(buffer, :count, count + 1)
  end
end
