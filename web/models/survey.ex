defmodule KlziiChat.Survey do
  use KlziiChat.Web, :model

  schema "Surveys" do
    belongs_to :resource, KlziiChat.Resource, [foreign_key: :resourceId]
    belongs_to :account, KlziiChat.Account, [foreign_key: :accountId]
    has_many :survey_questions, KlziiChat.SurveyQuestion, [foreign_key: :surveyId]
    field :name, :string
    field :description, :string
    field :thanks, :string
    field :closed, :boolean
    field :confirmedAt, Timex.Ecto.DateTime
    field :url, :string
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [])
  end
end
