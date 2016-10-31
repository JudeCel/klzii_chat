defmodule KlziiChat.Services.Reports.Types.Votes.Formats.Txt do
  alias KlziiChat.Decorators.MessageDecorator
  alias KlziiChat.Helpers.DateTimeHelper

  @spec processe_data(Map.t) :: {String.t}
  def processe_data(data) do
    render_string(data)
  end

  @spec render_string( Map.t) :: {:ok, String.t} | {:error, Map.t}
  def render_string(data) do
    session = get_in(data, ["session"])
    default_fields = get_in(data, ["default_fields"])
    [session_topic |_ ] = get_in(data, ["session_topics"])

    header = "#{session.name} / #{session_topic.name}\r\n\r\n"

    stream =
      session_topic.messages
      |> Stream.map(&get_data(&1, session, default_fields))

    {:ok, Stream.concat([header], stream)}
  end

  @spec get_data(Map.t,  Map.t, List.T) :: List.t
  def get_data(message, session, default_fields) do
    row = Enum.map(default_fields, fn(field) ->
      get_value(field, message, session)
    end) |> Enum.join(", ")
    [row <> "\r\n\r\n"]
  end

  def get_value("First Name", _, _) do
    "First Name"
  end
  def get_value("Title", %{title: title}, _) do
    title
  end
  def get_value("Question", %{question: question}, _) do
    question
  end
  def get_value("Answer", _, _) do
    "Answer"
  end
  def get_value("Date", _, %{timeZone: time_zone}) do
    "Answer createdAt"
    # DateTimeHelper.report_format(createdAt, time_zone)
  end
end
