defmodule KlziiChat.SessionType do
  use KlziiChat.Web, :model

  @moduledoc """
    This Model is read only!
    Not use for insert or update!
  """
  
@primary_key {:name, :string, autogenerate: false}

  schema "SessionTypes" do
    field :properties, :map
    has_many :sessions, KlziiChat.Session, [foreign_key: :type]
  end
end
