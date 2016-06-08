defmodule KlziiChat.Console do
  use KlziiChat.Web, :model

  schema "Consoles" do
    belongs_to :sessionTopic, KlziiChat.SessionTopic, [foreign_key: :sessionTopicId]
    belongs_to :audio, KlziiChat.Resource, [foreign_key: :audioId]
    belongs_to :video, KlziiChat.Resource, [foreign_key: :videoId]
    belongs_to :image, KlziiChat.Resource, [foreign_key: :imageId]
    belongs_to :file, KlziiChat.Resource, [foreign_key: :fileId]
    belongs_to :mini_survey, KlziiChat.MiniSurvey, [foreign_key: :miniSurveyId]
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end

  @required_fields ~w(sessionTopicId)
  @optional_fields ~w(audioId videoId imageId fileId miniSurveyId )

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, (@required_fields ++ @optional_fields))
  end
end
