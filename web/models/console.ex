defmodule KlziiChat.Console do
  use KlziiChat.Web, :model

  schema "Consoles" do
    field :pinboard, :boolean, default: false
    belongs_to :sessionTopic, KlziiChat.SessionTopic, [foreign_key: :sessionTopicId]
    belongs_to :audio, KlziiChat.Resource, [foreign_key: :audioId]
    belongs_to :video, KlziiChat.Resource, [foreign_key: :videoId]
    belongs_to :file, KlziiChat.Resource, [foreign_key: :fileId]
    belongs_to :mini_survey, KlziiChat.MiniSurvey, [foreign_key: :miniSurveyId]
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:sessionTopicId, :audioId, :videoId, :pinboard, :fileId, :miniSurveyId ])
    |> validate_required([:sessionTopicId])
    |> validate_inclusion(:pinboard, [true, false])
  end
end
