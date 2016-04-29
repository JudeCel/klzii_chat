defmodule KlziiChat.SurveyQuestion do
  use KlziiChat.Web, :model

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

  @required_fields ~w()
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, (@required_fields ++  @optional_fields))
  end
end
