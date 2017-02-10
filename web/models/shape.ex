defmodule KlziiChat.Shape do
  use KlziiChat.Web, :model

  schema "Shapes" do
    belongs_to :session_topic, KlziiChat.SessionTopic, [foreign_key: :sessionTopicId]
    belongs_to :session_member, KlziiChat.SessionMember, [foreign_key: :sessionMemberId]
    field :event, :map
    field :uid, :string
    field :eventType, :string
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:sessionTopicId, :uid, :sessionMemberId, :event])
    |> validate_required([:sessionTopicId, :uid, :sessionMemberId, :event])
    |> set_evant_type()
  end

  def set_evant_type(base_changeset) do
    case base_changeset do
      %Ecto.Changeset{changes: %{event: event}} when is_map(event) ->
        case event do
          %{"type" => type} ->
            put_change(base_changeset, :eventType, type)
          _ ->
            base_changeset
        end
      _ ->
        base_changeset
    end
  end
end
