defmodule KlziiChat.Resource do
  use KlziiChat.Web, :model
  use Arc.Ecto.Model

  schema "Resources" do
    belongs_to :topic, KlziiChat.Topic, [foreign_key: :topicId]
    belongs_to :user, KlziiChat.User, [foreign_key: :userId]
    field :JSON, :map
    field :HTML, :string
    field :URL, KlziiChat.ResourceImage.Type
    field :thumb_URL, :string
    field :resourceType, :string
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end

  @required_fields ~w(resourceType topicId userId)
  @optional_fields ~w(JSON HTML)

  @required_file_fields ~w()
  @optional_file_fields ~w(URL)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> cast_attachments(params, @required_file_fields, @optional_file_fields)
  end
end
