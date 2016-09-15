defmodule KlziiChat.Reporting.MessagesView do

  use KlziiChat.Web, :view

  def report_logo_url do
    KlziiChat.Reporting.PreviewView.report_logo_url
    |> path_to_assets

  end

  def get_emotion_url(emotion) do
    KlziiChat.Reporting.PreviewView.get_emotion_url(emotion)
    |> path_to_assets
  end

  def media_image_position(message) do
    "emotion-chat-section push-image " <> if(length(message.replies) > 0, do: "media-top", else:  "media-bottom")
  end

  def facilitator_color(message) do
    if message.session_member.role == "facilitator" do
      "color: #{message.session_member.colour}"
    end
  end

  def path_to_assets(path) do
    Path.expand("./web/static/assets") <> path
  end

  def path_to_js_css(path) do
    Path.expand("./web/static") <> path
  end
end
