defmodule KlziiChat.Invite do
  use KlziiChat.Web, :model

  @moduledoc """
    This Mode is read only!
    Not use for insert!
  """
  schema "Invites" do
    belongs_to :account, KlziiChat.Account, [foreign_key: :accountId]
    belongs_to :user, KlziiChat.User, [foreign_key: :userId]
    belongs_to :account_user, KlziiChat.AccountUser, [foreign_key: :accountUserId]
    belongs_to :session, KlziiChat.Session, [foreign_key: :sessionId]
    field :role, :string
    field :sentAt, Timex.Ecto.DateTime
    field :webhookTime, Timex.Ecto.DateTime
    field :token, :string
    field :mailMessageId, :string
    field :mailProvider, :string
    field :webhookMessage, :string
    field :webhookEvent, :string
    field :status, :string
    field :emailStatus, :string

    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]

  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:emailStatus, :webhookTime, :webhookEvent, :webhookMessage])
    |> validate_required([:emailStatus, :webhookTime, :webhookEvent, :webhookMessage])
  end
end
