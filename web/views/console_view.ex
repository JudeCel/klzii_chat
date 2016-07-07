defmodule KlziiChat.ConsoleView do
  use KlziiChat.Web, :view

  def render("show.json", %{console: console})do
    %{audio_id: console.audioId,
      pinboard: console.pinboard,
      video_id: console.videoId,
      file_id: console.fileId,
      mini_survey_id: console.miniSurveyId
    }
  end
end
