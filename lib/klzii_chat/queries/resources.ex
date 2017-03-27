defmodule KlziiChat.Queries.Resources do
  import Ecto
  import Ecto.Query

  alias KlziiChat.{AccountUser, Resource}

  @spec base_query(%AccountUser{}) :: Ecto.Query.t
  def base_query(account_user) do
    from(r in assoc(account_user.account, :resources), where: r.scope != "banner")
  end

  @spec by_account_or_stock_query(%AccountUser{}) :: Ecto.Query.t
  def by_account_or_stock_query(account_user) do
    account_id = account_user.account.id
    from(r in Resource, join: a in assoc(r, :account), where: a.id == ^account_id or r.stock)
  end

  @spec base_query() :: Ecto.Query.t
  def base_query() do
    from(r in Resource, where: r.scope != "banner")
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

  @spec get_by_ids(Ecto.Query.t,Listr.t) :: Ecto.Query.t
  def get_by_ids(query, ids) do
    from(r in query, where: r.id in ^ids)
  end

  @spec where_stock(Ecto.Query.t, Boolean.t) :: Ecto.Query.t
  def where_stock(query, stock) do
    from(r in query, where: r.stock == ^stock)
  end

  @spec get_by_ids_used(Listr.t) :: Ecto.Query.t
  def get_by_ids_used(ids) do
    from(r in Resource, left_join: sr in assoc(r, :session_resources), left_join: s in assoc(sr, :session), left_join: s2 in assoc(r, :sessions), left_join: mtr in assoc(r, :mail_template_resources),
      where: r.id in ^ids,
      where: s.status == "open" or s2.status == "open" or not is_nil(mtr.mailTemplateId),
      where: r.stock == false,
      distinct: true
    )
  end

  @spec get_by_ids_for_closed_session(Listr.t) :: Ecto.Query.t
  def get_by_ids_for_closed_session(ids) do
    from(r in Resource, left_join: sr in assoc(r, :session_resources), left_join: s in assoc(sr, :session), left_join: s2 in assoc(r, :sessions),
      where: r.id in ^ids,
      where: s.status == "closed" or s2.status == "closed",
      where: r.stock == false,
      distinct: true
    )
  end

  @spec exclude(Ecto.Query.t, [%KlziiChat.Resource{}]) :: Ecto.Query.t
  def exclude(query, resources) do
    resource_ids = Enum.map(resources, fn(%{id: id}) -> id end)
    from(r in query, where: not r.id in ^resource_ids)
  end

  @spec exclude_by_ids(Ecto.Query.t, [%KlziiChat.SessionResource{}]) :: Ecto.Query.t
  def exclude_by_ids(query, session_resources) do
    session_resource_ids = Enum.map(session_resources, fn(%{resourceId: resource_id}) -> resource_id end)
    from(r in query, where: not r.id in ^session_resource_ids)
  end

  def skip_reports(query) do
    from(r in query, left_join: sr in assoc(r, :session_topics_reports), where: is_nil(sr.id))
  end
end
