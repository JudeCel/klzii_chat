defmodule KlziiChat.ConsoleView do
  use KlziiChat.Web, :view

  def render("show.json", %{console: console})do
    %{audio_id: console.audioId, image_id: console.imageId, video_id: console.videoId,
      file_id: console.fileId, survey_id: console.surveyId}
  end
end
