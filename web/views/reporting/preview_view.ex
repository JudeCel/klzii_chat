defmodule KlziiChat.Reporting.PreviewView do
  use KlziiChat.Web, :view

  def report_logo_url() do
    "/images/klzii_logo.png"
  end

  def get_emotion_url(emotion) do
    "/images/emotions_static/emotion-#{emotion}.png"
  end

  def media_image_position(message) do
    "emotion-chat-section push-image " <> if(length(message.replies) > 0, do: "media-top", else:  "media-bottom")
  end

  def facilitator_color(message) do
    if message.session_member.role == "facilitator" do
      "color: #{message.session_member.colour}"
    end
  end
end
