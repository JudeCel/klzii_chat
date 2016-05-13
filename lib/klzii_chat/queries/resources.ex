defmodule KlziiChat.Queries.Resources do
  import Ecto
  import Ecto.Query

  alias KlziiChat.{Resource, AccountUser}
  alias KlziiChat.Services.SessionResourcesService

  def add_role_scope(account_user = %AccountUser{role: "admin"}) do
    from(r in assoc(account_user.account, :resources))
  end
  def add_role_scope(account_user) do
    from(r in assoc(account_user.account, :resources), where: [private: false])
  end

  def find_by_params(base_query, params) do
    build_type(base_query, params) |> build_scope(params)
  end

  def build_type(query, %{"type" => type}) when is_list(type) do
    from r in query, where: r.type in ^type
  end
  def build_type(query, %{"type" => type})  do
     from r in query, where: r.type == ^type
  end
  def build_type(query,_)  do
    query
  end

  def build_scope(query, %{"scope" => scope}) when is_list(scope) do
    from r in query, where: r.scope in ^scope
  end
  def build_scope(query, %{"scope" => scope})  do
    from r in query, where: r.scope == ^scope
  end
  def build_scope(query, _)  do
    query
  end

  def exclude_by_session_id(query, account_user_id, session_member_id) do
    {:ok, session_resources} = SessionResourcesService.get_session_resources(session_member_id)
    session_resource_ids = Enum.map(session_resources, fn(%{resourceId: resource_id}) -> resource_id end)
    from(r in query, where: not r.id in ^session_resource_ids and r.accountId  == ^account_user_id)
  end
end
