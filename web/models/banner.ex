defmodule KlziiChat.Banner do
  use KlziiChat.Web, :model

  @moduledoc """
    This Mode is read only!
    Not use for insert!
  """

  schema "Banners" do
    belongs_to :resource, KlziiChat.Resource, [foreign_key: :resourceId]
    field :page, :string
    field :link, :string
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [])
  end
end
