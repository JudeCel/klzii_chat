defmodule KlziiChat.Services.ConsoleService do
  alias KlziiChat.{Repo, Console, Console, SessionTopic, Resource}
  import Ecto
  import Ecto.Query, only: [from: 1, from: 2]

  @spec get(Integer, Integer) ::  {:ok, %Console{}}
  def get(session_id, topic_id) do
    session_topic = from(st in SessionTopic,
      where: st.sessionId == ^session_id,
      where: st.topicId == ^topic_id,
      preload: [:console]
    ) |> Repo.one

    case session_topic.console do
      nil ->
        build_assoc(session_topic, :console) |> Repo.insert
      console ->
        {:ok, console}
    end
  end

  @spec add_resource(Integer, Integer, Integer) ::  {:ok, %Console{}}
  def add_resource(session_id, topic_id, resource_id) do
    resource = Repo.get!(Resource, resource_id)
    {:ok, console} = get(session_id, topic_id)
    changeset = Map.put(%{}, String.to_atom("#{resource.type}Id" ), resource.id)
    Console.changeset(console, changeset)
      |> Repo.update
  end
end
