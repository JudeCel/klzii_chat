defmodule KlziiChat.Reporting.PreviewView do
  use KlziiChat.Web, :view

  def get_emotion_url(emotion) do
    "/images/emotions_static/#{emotion}_sprite_01.jpg"
  end

  def media_image_position(message) do
    "emotion-chat-section push-image " <> if(length([ message.replies ]) > 0, do: "media-top", else:  "media-bottom")
  end

  def body_classname(message) do
    "body-section col-md-12 #{message.session_member.role}"
  end

  def emotion_chat_class(message) do
    "emotion-chat-#{message.emotion}"
  end
end
