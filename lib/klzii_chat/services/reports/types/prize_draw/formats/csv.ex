defmodule KlziiChat.Services.Reports.Types.PrizeDraw.Formats.Csv do
  @spec processe_data(Map.t) :: {String.t}
  def processe_data(data) do
    render_string(data)
  end

  @spec render_string( Map.t) :: {:ok, String.t} | {:error, Map.t}
  def render_string(data) do
    fields = get_in(data, ["fields"])
    {:ok, acc} = Agent.start_link(fn -> [] end)

      get_in(data, ["prize_draw_surveys"])
      |> Task.async_stream(fn(session_survey) -> process_results(session_survey, fields, acc) end)
      |> Enum.to_list()
    {:ok, %{header: fields, data: acc}}
  end

  def process_results(session_survey, fields, acc) do
    survey_questions =
      get_in(session_survey, [:survey, :survey_questions])
      |> Enum.map(&({&1.name, "#{&1.id}"})) |> Enum.into(%{})
    answers = get_in(session_survey, [:survey, :survey_answers])
    map_data(answers, survey_questions, fields, acc)
  end

  def map_data([], _, _, acc), do: acc
  def map_data([head | tail], survey_questions, fields, acc) do
    map_data(head, survey_questions, fields, acc)
    map_data(tail, survey_questions, fields, acc)
  end
  def map_data(%{answers: answers}, survey_questions, fields, acc) do
    if get_in(answers, [survey_questions["Interest"], "value"]) == 0 do
      contactDetails = get_in(answers, [survey_questions["Contact Details"], "contactDetails"])

      answer =
        Enum.reduce(fields, %{}, fn(field, local_acc) ->
          Map.put(local_acc, field, get_field(field, contactDetails))
        end)

        :ok = Agent.update(acc, fn(data) -> data ++  [answer] end)
    end
  end

  def get_field("First Name", contactDetails), do: get_in(contactDetails, ["firstName"])
  def get_field("Last Name", contactDetails), do: get_in(contactDetails, ["lastName"])
  def get_field("Email", contactDetails), do: get_in(contactDetails, ["email"])
  def get_field("Contact Number", contactDetails) , do: get_in(contactDetails, ["mobile"])
  def get_field(_, _) , do: ""
end
