defmodule KlziiChat.Resource do
  use KlziiChat.Web, :model
  use Arc.Ecto.Schema
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

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(resource, params \\ %{}) do
    resource
    |> cast(params, [:status, :scope, :type, :accountUserId, :accountId, :name, :link, :properties])
    |> validate_required([:status, :scope, :type, :accountUserId, :accountId, :name])
    |> cast_attachments(params,["file", "image", "audio", "video"])
    |> parse_link
  end

  def banner_changeset(model, params \\ %{}) do
    model
    |> cast(params, [:status, :scope, :type, :accountUserId, :accountId, :name, :link, :properties])
    |> validate_required([:status, :scope, :type, :accountUserId, :accountId, :name, :link])
    |> cast_attachments(params, ["file", "image", "audio", "video"])
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
