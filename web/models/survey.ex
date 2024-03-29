defmodule KlziiChat.Survey do
  use KlziiChat.Web, :model

  @moduledoc """
    This Mode is read only!
    Not use for insert!
  """

  schema "Surveys" do
    belongs_to :resource, KlziiChat.Resource, [foreign_key: :resourceId]
    belongs_to :account, KlziiChat.Account, [foreign_key: :accountId]
    has_many :survey_questions, KlziiChat.SurveyQuestion, [foreign_key: :surveyId]
    has_many :survey_answers, KlziiChat.SurveyAnswer, [foreign_key: :surveyId]
    has_many :session_surveys, KlziiChat.SessionSurvey, [foreign_key: :surveyId]
    field :name, :string
    field :description, :string
    field :thanks, :string
    field :closed, :boolean
    field :confirmedAt, Timex.Ecto.DateTime
    field :url, :string
    field :surveyType, :string
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end
end
