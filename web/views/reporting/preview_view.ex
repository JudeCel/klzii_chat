defmodule KlziiChat.Reporting.PreviewView do
  use KlziiChat.Web, :view
  import(KlziiChat.Reporting.MessagesView, only: [media_image_position: 1, facilitator_color: 1 ])

  def report_logo_url() do
    "/images/klzii_logo.png"
  end

  def get_emotion_url(emotion) do
    "/images/emotions_static/emotion-#{emotion}.png"
  end
end
