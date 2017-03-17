defmodule KlziiChat.Reporting.PreviewView do
  use KlziiChat.Web, :view

  def brand_logo_path(nil, %{url: url, static: false}), do: url.full
  def brand_logo_path(nil, %{url: url, static: true}), do: Path.expand("./web/static/assets") <> url.full
  def brand_logo_path(nil, nil), do: nil
  def brand_logo_path(_, %{url: url, static: false}), do: url.full
  def brand_logo_path(_, %{url: url, static: true}), do: url.full

  def get_emotion_url(emotion) do
    "/images/emotions_static/emotion-#{emotion}.png"
  end

  def media_image_position(message) do
    "emotion-chat-section push-image " <> if(length(message.replies) > 0, do: "media-top", else:  "media-bottom")
  end

  def time_format(time, time_zone) do
    KlziiChat.Helpers.DateTimeHelper.report_format(time, time_zone)
  end

  def facilitator_color(message) do
    if message.session_member.role == "facilitator" do
      "color: #{message.session_member.colour}"
    end
  end

  def get_mini_survey_answer(%{ "type" => type, "value" => value }) do
    {:ok, result} = KlziiChat.Decorators.MiniSurveyAnswersDecorator.answer_text(type, value)
    result
  end
  def all_shapes(topics) do
    Enum.map(topics, fn(topic) ->
      topic.shapes
    end)
  end

  def get_answers(%{answers: answers, type: "textarea" }) do
    List.first(answers)
    |> Map.get(:values)
    |> Enum.map(fn(answer) ->
      %{name: answer, count: nil, percents: nil}
     end)
  end
  def get_answers(%{answers: answers}) do
    answers
  end
end
