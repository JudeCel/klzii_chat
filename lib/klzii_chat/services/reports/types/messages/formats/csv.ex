defmodule KlziiChat.Services.Reports.Types.Messages.Formats.Csv do

  alias KlziiChat.Decorators.MessageDecorator
  require Elixlsx
  alias Elixlsx.Sheet
  alias Elixlsx.Workbook


  @spec processe_data(Map.t) :: {String.t}
  def processe_data(data) do
    render_string(data)
  end

  @spec render_string( Map.t) :: {:ok, String.t} | {:error, Map.t}
  def render_string(data) do
    session = get_in(data, ["session"])
    sheet1 = Sheet.with_name("First")
    workbook = %Workbook{sheets: []}
    Enum.each(enumerable, fun)

    # workbook =
    #   get_in(data, ["session_topics"])
    #   |> Enum.each(&message_csv_filter(get_in(&1, [:messages]), session.timeZone))
      Elixlsx.write_to(workbook, "empty.xlsx")
    {:ok, workbook}
  end

  @spec message_csv_filter(Map.t,  String.t) :: String.t
  def message_csv_filter(%{session_member: %{username: username}, body: body, createdAt: createdAt, star: star,
    replyId: replyId, emotion: emotion}, time_zone) do
    {:ok, emotion_name} = MessageDecorator.emotion_name(emotion)

    %{ "Name" => username,
       "Comment" => body,
       "Date" => DateTimeHelper.report_format(createdAt, time_zone),
       "Is reply" => to_string(replyId != nil),
       "Emotion" => emotion_name
      }
  end

end
