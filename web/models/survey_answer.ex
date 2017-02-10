defmodule KlziiChat.SurveyAnswer do
  use KlziiChat.Web, :model

  @moduledoc """
    This Mode is read only!
    Not use for insert!
  """

  schema "SurveyAnswers" do
    belongs_to :survey, KlziiChat.Survey, [foreign_key: :surveyId]
    field :answers, :map
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end
end
