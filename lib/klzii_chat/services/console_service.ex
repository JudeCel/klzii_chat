defmodule KlziiChat.Services.ConsoleService do
  alias KlziiChat.{Repo, Console, Console, SessionTopic, Resource, MiniSurvey, SessionMember, ConsoleView, Endpoint}
  alias KlziiChat.Services.Permissions.Console, as: ConsolePermissions
  import Ecto

  @spec error_messages :: Map.t
  def error_messages do
    %{
      action_not_allowed:  "Action not allowed!"
    }
  end


  @spec get(Integer, Integer) ::  {:ok, %Console{}}
  def get(_, session_topic_id) do
    session_topic = Repo.get!(SessionTopic, session_topic_id) |> Repo.preload([:console])
    case session_topic.console do
      nil ->
        build_assoc(session_topic, :console) |> Repo.insert
      console ->
        {:ok, console}
    end
  end

  @spec set_resource(Integer, Integer, Integer) :: {:ok, %Console{}} | {:error, String.t}
  def set_resource(member_id, session_topic_id, resource_id) do
    session_member = Repo.get!(SessionMember, member_id)
    if ConsolePermissions.can_set_resource(session_member) do
      {:ok, console} = get(session_member.sessionId, session_topic_id)
      set_id_by_type(resource_id, :resource)
      |> update_console(console)
    else
      {:error, errors_messages.action_not_allowed}
    end
  end

  @spec enable_pinboard(Integer, Integer) :: {:ok, %Console{}} | {:error, String.t}
  def enable_pinboard(member_id, session_topic_id) do
    session_member = Repo.get!(SessionMember, member_id)
    if ConsolePermissions.can_enable_pinboard(session_member) do
      {:ok, console} = get(session_member.sessionId, session_topic_id)
      set_id_by_type(resource_id, :resource)
      |> update_console(console)
    else
      {:error, errors_messages.action_not_allowed}
    end
  end

  def tidy_up(consoles, type, session_member_id) do
    Enum.each(consoles, fn console ->
      {:ok, new_console} = remove(session_member_id, console.sessionTopicId, type)
      data = ConsoleView.render("show.json", %{console: new_console})
      Endpoint.broadcast!( "session_topic:#{console.sessionTopicId}", "console", data)
    end)
  end

  @spec set_mini_survey(Integer, Integer, Integer) :: {:ok, %Console{}} | {:error, String.t}
  def set_mini_survey(member_id, session_topic_id, mini_survey_id) do
    session_member = Repo.get!(SessionMember, member_id)
    if ConsolePermissions.can_set_resource(session_member) do
      {:ok, console} = get(session_member.sessionId, session_topic_id)
      set_id_by_type(mini_survey_id, :mini_survey)
      |> update_console(console)
    else
      {:error, errors_messages.action_not_allowed}
    end
  end

  @spec remove(Integer, Integer, String.t) ::  {:ok, %Console{}} | {:error, String.t}
  def remove(member_id, session_topic_id, type) do
    session_member = Repo.get!(SessionMember, member_id)
    if ConsolePermissions.can_remove_resource(session_member) do
      {:ok, console} = get(session_member.sessionId, session_topic_id)
      remove_id_by_type(type)
      |> update_console(console)
    else
      {:error, errors_messages.action_not_allowed}
    end
  end

  @spec update_console(Map, %Console{}) :: {:ok, %Console{}}
  defp update_console(changeset, console) do
    Console.changeset(console, changeset) |> Repo.update
  end

  @spec set_id_by_type(Integer, Atom) :: Map
  defp set_id_by_type(mini_survey_id, :mini_survey) when is_integer(mini_survey_id) do
    mini_survey = Repo.get!(MiniSurvey, mini_survey_id)
    Map.put(%{},get_field_from_type("miniSurvey"), mini_survey.id)
  end

  @spec set_id_by_type(Integer, Atom) :: Map
  defp set_id_by_type(resource_id, :resource) when is_integer(resource_id) do
    resource = Repo.get!(Resource, resource_id)
    Map.put(%{},get_field_from_type(resource.type), resource.id)
  end

  @spec remove_id_by_type(String.t) :: Map
  defp remove_id_by_type(type) do
    Map.put(%{}, get_field_from_type(type), nil)
  end

  @spec get_field_from_type(String.t) :: Atom.t
  def get_field_from_type(resurce_type) do
    case resurce_type do
      "link" ->
        String.to_atom("videoId")
      type ->
        String.to_atom("#{type}Id" )
    end
  end
end
