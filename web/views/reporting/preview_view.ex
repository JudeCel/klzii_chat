defmodule KlziiChat.Reporting.PreviewView do
  use KlziiChat.Web, :view

  def get_emotion_url(emotion) do
    "/images/emotions_static/#{emotion}_sprite_01.jpg"
  end
  
end
