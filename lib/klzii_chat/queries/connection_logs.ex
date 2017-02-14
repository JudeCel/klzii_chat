defmodule KlziiChat.Queries.ConnectionLogs do
  alias KlziiChat.{ConnectionLog}
  import Ecto.Query

  @spec base() :: Ecto.Query
  def base() do
    from(cl in ConnectionLog)
  end

  def filter(query, %{"accountId"=>  id} = filter) when is_integer(id) do
    query
    |> where([cl], cl.accountId == ^id)
    |> filter(Map.drop(filter, ["accountId"]))
  end
  def filter(query, %{"userId" => id} = filter) when is_integer(id) do
    query
    |> where([cl], cl.userId == ^id)
    |> filter(Map.drop(filter, ["userId"]))
  end
  def filter(query, %{"accountUserId" =>  id} = filter) when is_integer(id) do
    query
    |> where([cl], cl.accountUserId == ^id)
    |> filter(Map.drop(filter, ["accountUserId"]))
  end
  def filter(query, %{"limit" =>  limit_count} = filter) when is_integer(limit_count) do
    query
    |> limit(^limit_count)
    |> filter(Map.drop(filter, ["limit"]))
  end
  def filter(query, _) do
    query
  end
end
