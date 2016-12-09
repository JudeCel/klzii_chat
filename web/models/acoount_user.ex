defmodule KlziiChat.AccountUser do
  use KlziiChat.Web, :model

  @moduledoc """
    This Mode is read only!
    Not use for insert!
  """

  schema "AccountUsers" do
    belongs_to :user, KlziiChat.User, [foreign_key: :UserId]
    belongs_to :account, KlziiChat.Account, [foreign_key: :AccountId]
    has_many :session_members, KlziiChat.SessionMember, [foreign_key: :accountUserId]
    field :firstName, :string
    field :lastName, :string
    field :gender, :string
    field :role, :string
    field :email, :string
    field :state, :string
    field :postalAddress, :string
    field :city, :string
    field :country, :string
    field :postCode, :string
    field :companyName, :string
    field :landlineNumber, :string
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end
end
