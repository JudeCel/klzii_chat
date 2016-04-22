defmodule KlziiChat.Resource do
  use KlziiChat.Web, :model
  use Arc.Ecto.Model
  alias KlziiChat.Uploaders.{Image, Video, File, Audio}
  alias KlziiChat.Files.UrlHelpers

  schema "Resources" do
    belongs_to :account_user, KlziiChat.AccountUser, [foreign_key: :accountUserId]
    belongs_to :account, KlziiChat.Account, [foreign_key: :accountId]
    field :image, Image.Type
    field :audio, Audio.Type
    field :file, File.Type
    field :video, Video.Type
    field :link, :string
    field :type, :string
    field :scope, :string
    field :name, :string
    field :status, :string, default: "completed"
    field :properties, :map, default: %{}
    field :expiryDate, Timex.Ecto.DateTime
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end

  @required_fields ~w(status scope type accountUserId accountId name)
  @optional_fields ~w(link properties)

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
    |> parse_link
  end

  defp parse_link(base_changeset) do
    case base_changeset do
      %Ecto.Changeset{valid?: true, changes: %{type: "link", scope: "youtube", link: link}} ->
        put_change(base_changeset, :link, UrlHelpers.youtube_id(link))
      _ ->
        base_changeset
    end
  end
end
