defmodule KlziiChat.Resource do
  use KlziiChat.Web, :model
  use Arc.Ecto.Model
  alias KlziiChat.Uploaders.{Image, Video, File, Audio}

  schema "Resources" do
    belongs_to :session_member, KlziiChat.SessionMember, [foreign_key: :sessionMemberId]
    belongs_to :topic, KlziiChat.Topic, [foreign_key: :topicId]
    field :image, Image.Type
    field :audio, Audio.Type
    field :file, File.Type
    field :video, Video.Type
    field :link, :string
    field :type, :string
    field :scope, :string
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end

  @required_fields ~w(topicId scope type sessionMemberId)
  @optional_fields ~w(link)

  @required_file_fields ~w()
  @optional_file_fields ~w(file image audio video)

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
