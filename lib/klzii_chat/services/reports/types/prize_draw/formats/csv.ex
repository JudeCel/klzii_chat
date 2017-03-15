defmodule KlziiChat.Services.Reports.Types.PrizeDraw.Formats.Csv do
  @spec processe_data(Map.t) :: {String.t}
  def processe_data(data) do
    render_string(data)
  end

  @spec render_string( Map.t) :: {:ok, String.t} | {:error, Map.t}
  def render_string(data) do
    fields = get_in(data, ["fields"])
    answers = get_in(data, ["prize_draw_survey", :survey, :survey_answers])
    {:ok, acc} = Agent.start_link(fn -> [] end)
    map_data(answers, fields, acc)
    {:ok, %{header: fields, data: acc}}
  end

  def map_data([], _, acc), do: acc
  def map_data([head | tail], fields, acc) do
    map_data(head, fields, acc)
    map_data(tail, fields, acc)
  end
  def map_data(%{answers: answers}, fields, acc) do
    contactDetails = get_in(answers, ["2", "contactDetails"])
    
    answer =
      Enum.reduce(fields, %{}, fn(field, local_acc) ->
        Map.put(local_acc, field, get_field(field, contactDetails))
      end)

    :ok = Agent.update(acc, fn(data) -> data ++  [answer] end)
  end

  def get_field("First Name", contactDetails), do: get_in(contactDetails, ["firstName"])
  def get_field("Last Name", contactDetails), do: get_in(contactDetails, ["lastName"])
  def get_field("Email", contactDetails), do: get_in(contactDetails, ["email"])
  def get_field("Contact Number", contactDetails) , do: get_in(contactDetails, ["mobile"])
  def get_field(_, _) , do: ""
end
