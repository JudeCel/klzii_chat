defmodule KlziiChat.SurveyQuestion do
  use KlziiChat.Web, :model

  @moduledoc """
    This Mode is read only!
    Not use for insert!
  """

  schema "SurveyQuestions" do
    belongs_to :resource, KlziiChat.Resource, [foreign_key: :resourceId]
    belongs_to :survey, KlziiChat.Survey, [foreign_key: :surveyId]
    field :name, :string
    field :question, :string
    field :order, :integer
    field :type, :string
    field :answers, {:array, :map}
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end
end
