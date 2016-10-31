defmodule KlziiChat.Services.Reports.Types.Messages.Formats.Txt do
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
      get_value_for_message(field, message, session)
    end) |> Enum.join(", ")
    [row <> "\r\n\r\n"]
  end

  def get_value_for_message("First Name", %{session_member: %{username: username}}, _) do
    username
  end
  def get_value_for_message("Comment", %{body: body}, _) do
    body
  end
  def get_value_for_message("Date", %{createdAt: createdAt}, %{timeZone: time_zone}) do
    DateTimeHelper.report_format(createdAt, time_zone)
  end
  def get_value_for_message("Is Reply", %{replyLevel: 0},_), do: to_string(true)
  def get_value_for_message("Is Reply", _,_), do: to_string(false)
  def get_value_for_message("Emotion", %{emotion: emotion},_) do
    {:ok, emotion_name} = MessageDecorator.emotion_name(emotion)
    emotion_name
  end
  def get_value_for_message("Is Star", %{star: star}, _), do: to_string(star)

end
