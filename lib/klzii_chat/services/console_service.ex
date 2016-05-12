defmodule KlziiChat.Services.ConsoleService do
  alias KlziiChat.{Repo, Console, Console, SessionTopic, Resource}
  alias KlziiChat.Services.Permissions.Console, as: ConsolePermissions
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

  @spec set_resource(Integer, Integer, Integer) ::  {:ok, %Console{}}
  def set_resource(member, topic_id, resource_id) do
    if ConsolePermissions.can_set_resource(member) do
      {:ok, console} = get(member.session_id, topic_id)
      set_id_by_action(resource_id, :add)
      |> update_console(console)
    else
      {:error, "Action not allowed!"}
    end
  end

  @spec remove_resource(Integer, Integer, Integer) ::  {:ok, %Console{}}
  def remove_resource(member, topic_id, resource_id) do
    if ConsolePermissions.can_remove_resource(member) do
      {:ok, console} = get(member.session_id, topic_id)
      set_id_by_action(resource_id, :remove)
      |> update_console(console)
    else
      {:error, "Action not allowed!"}
    end
  end

  def update_console(changeset, console) do
    Console.changeset(console, changeset) |> Repo.update
  end

  def set_id_by_action(resource_id, action) do
    resource = Repo.get!(Resource, resource_id)
    id = case action do
      :add ->
          resource.id
      :remove ->
        nil
      _ ->
        nil
    end
    Map.put(%{}, String.to_atom("#{resource.type}Id" ), id)
  end
end
