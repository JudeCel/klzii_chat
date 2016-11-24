defmodule KlziiChat.Resource do
  use KlziiChat.Web, :model
  use Arc.Ecto.Schema
  alias KlziiChat.Uploaders.{Image, Video, File, Audio}
  alias KlziiChat.Files.UrlHelpers

  schema "Resources" do
    belongs_to :account_user, KlziiChat.AccountUser, [foreign_key: :accountUserId]
    belongs_to :account, KlziiChat.Account, [foreign_key: :accountId]
    has_many :session_resources, KlziiChat.SessionResource, [foreign_key: :resourceId]
    has_many :sessions, KlziiChat.Session, [foreign_key: :resourceId]
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
    field :stock, :boolean, default: false
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
    |> cast(params, [:status, :scope, :type, :accountUserId, :accountId, :name, :link, :properties, :stock])
    |> validate_required([:status, :scope, :type, :accountUserId, :accountId, :name, :stock])
    |> validate_length(:name, max: 30,  message: "Max length of file name is 30 characters")
    |> unique_constraint(:name, name: :UniqResourceNameByAccount, message: "Resource name has already been taken")
    |> cast_attachments(params, ["file", "image", "audio", "video"])
    |> parse_link
  end

  def banner_changeset(model, params \\ %{}) do
    model
    |> cast(params, [:status, :scope, :type, :accountUserId, :accountId, :name, :link, :properties])
    |> validate_required([:status, :scope, :type, :accountUserId, :accountId, :name, :link])
    |> validate_length(:name, max: 30, message: "Max length of file name is 30 characters")
    |> unique_constraint(:name, name: :UniqResourceNameByAccount, message: "Resource name has already been taken")
    |> cast_attachments(params, ["file", "image", "audio", "video"])
  end

  def report_changeset(model, params \\ %{}) do
    model
    |> cast(params, [:status, :scope, :type, :accountId, :name])
    |> validate_required([:status, :scope, :type, :accountId, :name])
    |> unique_constraint(:name, name: :UniqResourceNameByAccount, message: "Resource name has already been taken")
    |> cast_attachments(params, ["file"])
  end

  defp parse_link(base_changeset) do
    case base_changeset do
      %Ecto.Changeset{valid?: true, changes: %{link: link}} when is_bitstring(link) ->
        put_change(base_changeset, :link, UrlHelpers.youtube_id(link))
      _ ->
        base_changeset
    end
  end
end
