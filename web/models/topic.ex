defmodule KlziiChat.Topic do
  use KlziiChat.Web, :model

  @moduledoc """
    For this model allow change only boardMessage
  """
  schema "Topics" do
    has_many :session_topics, KlziiChat.SessionTopic, [foreign_key: :topicId]
    has_many :sessions, through: [:session_topics, :sessionId]
    belongs_to :account, KlziiChat.Account, [foreign_key: :accountId]
    field :name, :string
    field :sign, :string
    field :boardMessage, :string
    field :board_message_text, :string, virtual: true
    field :stock, :boolean
    field :default, :boolean, default: false
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
