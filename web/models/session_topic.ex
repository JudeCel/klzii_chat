defmodule KlziiChat.SessionTopic do
  use KlziiChat.Web, :model

  @moduledoc """
    For this model allow insert only: boardMessage, field
  """

  schema "SessionTopics" do
    belongs_to :session, KlziiChat.Session, [foreign_key: :sessionId]
    belongs_to :topic, KlziiChat.Topic, [foreign_key: :topicId]
    has_many :messages, KlziiChat.Message, [foreign_key: :sessionTopicId]
    has_many :shapes, KlziiChat.Shape, [foreign_key: :sessionTopicId]
    has_one :console, KlziiChat.Console,[foreign_key: :sessionTopicId]
    has_many :mini_surveys, KlziiChat.MiniSurvey, [foreign_key: :sessionTopicId]
    field :boardMessage, :string
    field :board_message_text, :string, virtual: true
    field :order, :integer
    field :name, :string
    field :sign, :string
    field :landing, :boolean, default: false
    field :active, :boolean, default: true
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:boardMessage] )
    |> set_board_message_text
    |> validate_length(:board_message_text, max: 150, message: "Host Board Message is too long, max 150 characters")
  end


  def set_board_message_text(base_changeset) do
    case base_changeset do
      %Ecto.Changeset{valid?: true, changes: %{boardMessage: boardMessage}} when is_bitstring(boardMessage) ->
        text = Regex.replace(~r/<[^>]*>/, boardMessage, "")
        put_change(base_changeset, :board_message_text, text)
      _ ->
        base_changeset
    end
  end
end
