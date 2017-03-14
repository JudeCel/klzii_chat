defmodule KlziiChat.SessionSurvey do
  use KlziiChat.Web, :model

  @moduledoc """
    This Mode is read only!
    Not use for insert!
  """

  schema "SessionSurveys" do
    belongs_to :session, KlziiChat.Survey, [foreign_key: :sessionId]
    belongs_to :survey, KlziiChat.Survey, [foreign_key: :surveyId]
    field :active, :boolean
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end
end
