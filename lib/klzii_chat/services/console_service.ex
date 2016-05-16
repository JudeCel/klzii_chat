defmodule KlziiChat.Services.ConsoleService do
  alias KlziiChat.{Repo, Console, Console, SessionTopic, Resource, SessionMember}
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
  def set_resource(member_id, topic_id, resource_id) do
    session_member = Repo.get!(SessionMember, member_id)
    if ConsolePermissions.can_set_resource(session_member) do
      {:ok, console} = get(session_member.sessionId, topic_id)
      set_id_by_type(resource_id)
      |> update_console(console)
    else
      {:error, "Action not allowed!"}
    end
  end

  @spec remove_resource(Integer, Integer, String.t) ::  {:ok, %Console{}}
  def remove_resource(member_id, topic_id, type) do
    session_member = Repo.get!(SessionMember, member_id)
    if ConsolePermissions.can_remove_resource(session_member) do
      {:ok, console} = get(session_member.sessionId, topic_id)
      remove_id_by_type(type)
      |> update_console(console)
    else
      {:error, "Action not allowed!"}
    end
  end

  @spec update_console(Map, %Console{}) :: {:ok, %Console{}}
  defp update_console(changeset, console) do
    Console.changeset(console, changeset) |> Repo.update
  end

  @spec set_id_by_type(Integer) :: Map
  defp set_id_by_type(resource_id) when is_integer(resource_id) do
    resource = Repo.get!(Resource, resource_id)
    Map.put(%{},get_field_from_type(resource.type), resource.id)
  end

  @spec remove_id_by_type(String.t) :: Map
  defp remove_id_by_type(type) do
    Map.put(%{}, get_field_from_type(type), nil)
  end

  @spec get_field_from_type(String.t) :: Map
  def get_field_from_type(resurce_type) do
    case resurce_type do
      "link" ->
        String.to_atom("videoId")
      type ->
        String.to_atom("#{type}Id" )
    end
  end
end
