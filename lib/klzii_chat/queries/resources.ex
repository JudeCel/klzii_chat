defmodule KlziiChat.Queries.Resources do
  import Ecto
  import Ecto.Query

  alias KlziiChat.{AccountUser}

  @spec base_query(%AccountUser{}) :: Ecto.Query.t
  def base_query(account_user) do
    from(r in assoc(account_user.account, :resources))
  end

  @spec find_by_params(Ecto.Query.t, map) :: Ecto.Query.t
  def find_by_params(query, params) do
    build_type(query, params) |> build_scope(params)
  end

  @spec build_type(Ecto.Query.t, map) :: Ecto.Query.t
  def build_type(query, %{"type" => type}) when is_list(type) do
    from r in query, where: r.type in ^type
  end
  def build_type(query, %{"type" => type})  do
     from r in query, where: r.type == ^type
  end
  def build_type(query,_)  do
    query
  end

  @spec build_scope(Ecto.Query.t, map) :: Ecto.Query.t
  def build_scope(query, %{"scope" => scope}) when is_list(scope) do
    from r in query, where: r.scope in ^scope
  end
  def build_scope(query, %{"scope" => scope})  do
    from r in query, where: r.scope == ^scope
  end
  def build_scope(query, _)  do
    query
  end

  @spec exclude_by_ids(Ecto.Query.t, [%KlziiChat.SessionResource{}]) :: Ecto.Query.t
  def exclude_by_ids(query, session_resources) do
    session_resource_ids = Enum.map(session_resources, fn(%{resourceId: resource_id}) -> resource_id end)
    from(r in query, where: not r.id in ^session_resource_ids)
  end
end
