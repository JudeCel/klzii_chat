defmodule KlziiChat.Queries.Resources do
  import Ecto
  import Ecto.Query

  alias KlziiChat.{AccountUser, Resource, SessionResource}

  @spec base_query(%AccountUser{}) :: Ecto.Query.t
  def base_query(account_user) do
    from(r in assoc(account_user.account, :resources))
  end

  @spec base_query() :: Ecto.Query.t
  def base_query() do
    from(r in Resource)
  end

  @spec stock_query(Ecto.Query.t, map) :: Ecto.Query.t
  def stock_query(query, %{"stock" => stock})do
    from r in query, where: r.stock == ^stock
  end
  def stock_query(query, _)do
    from r in query, where: r.stock == false
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

  @spec preload_session_info(Ecto.Query.t) :: Ecto.Query.t
  def preload_session_info(query) do
    session_resources_query = from(sr in SessionResource, join: s in assoc(sr, :session), select: s.status, distinct: true)
    from(r in query, preload: [session_resources: ^session_resources_query])
  end

  @spec exclude_by_ids(Ecto.Query.t, [%KlziiChat.SessionResource{}]) :: Ecto.Query.t
  def exclude_by_ids(query, session_resources) do
    session_resource_ids = Enum.map(session_resources, fn(%{resourceId: resource_id}) -> resource_id end)
    from(r in query, where: not r.id in ^session_resource_ids)
  end
end
