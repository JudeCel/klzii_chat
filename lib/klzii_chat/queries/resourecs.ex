defmodule KlziiChat.Queries.Resources do
  import Ecto
  import Ecto.Query

  alias KlziiChat.{Resource, AccountUser}

  def add_role_scope(%AccountUser{role: "admin"}) do
    from(r in Resource)
  end
  def add_role_scope(_) do
    from(r in Resource, where: [private: false])
  end

  def add_role_scope(account_user) do
    from(r in assoc(account_user.account, :resources))
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
end
