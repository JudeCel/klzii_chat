defmodule KlziiChat.MiniSurvey do
  use KlziiChat.Web, :model

  schema "MiniSurveys" do
    belongs_to :session, KlziiChat.Session, [foreign_key: :sessionId]
    belongs_to :session_topic, KlziiChat.SessionTopic, [foreign_key: :sessionTopicId]
    has_many :mini_survey_answers, KlziiChat.MiniSurveyAnswer, [foreign_key: :miniSurveyId]
    has_many :consoles, KlziiChat.Console, [foreign_key: :miniSurveyId]
    field :title, :string
    field :question, :string
    field :type, :string
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:title, :question, :type, :sessionId, :sessionTopicId])
    |> validate_required([:title, :question, :type, :sessionId, :sessionTopicId])
    |> validate_inclusion(:type, ["yesNoMaybe", "5starRating"])
  end
end
