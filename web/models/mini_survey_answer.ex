defmodule KlziiChat.MiniSurveyAnswer do
  use KlziiChat.Web, :model

  schema "MiniSurveyAnswers" do
    belongs_to :session_member, KlziiChat.SessionMember, [foreign_key: :sessionMemberId]
    belongs_to :mini_survey, KlziiChat.MiniSurvey, [foreign_key: :miniSurveyId]
    field :answer, :map
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:messageId, :sessionMemberId, :answer])
    |> validate_required([:messageId, :sessionMemberId, :answer])
  end
end
