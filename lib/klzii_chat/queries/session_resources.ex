defmodule KlziiChat.Queries.SessionResources do
  import Ecto.Query, only: [from: 2]
  alias KlziiChat.{SessionResource}

  @spec get_by_resource_ids(Listr.t) :: Ecto.Query.t
  def get_by_resource_ids(ids) do
    from(sr in SessionResource,
      where: sr.resourceId in ^ids
    )
  end
end
