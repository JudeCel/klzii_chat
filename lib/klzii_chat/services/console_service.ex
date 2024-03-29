defmodule KlziiChat.Services.ConsoleService do
  alias KlziiChat.{Repo, Console, Console, SessionTopic, Resource, MiniSurvey, SessionMember, ConsoleView, Endpoint}
  alias KlziiChat.Services.Permissions.Console, as: ConsolePermissions
  import Ecto

  @spec error_messages() :: Map.t
  def error_messages() do
    %{
      pinboard_is_enable: "Sorry, can't add a resource when Pinboard enabled",
      other_resource_is_enable: "You can only load one media file per Topic"
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

  @spec resource_validations(boolean, %Console{}, %Resource{}) :: {:ok} | {:error, String.t}
  def resource_validations(has_permission, console, resource) do
    with {:ok} <- is_pinboard_enable?(console, :resource),
         {:ok} <- has_permission,
         {:ok} <- has_enable_resource(console, resource),
    do:  {:ok}
  end

  @spec is_pinboard_enable?(%Console{}, Atom) :: {:ok} | {:error, String.t}
  defp is_pinboard_enable?(console, :resource) do
    if console.pinboard, do: {:error, %{system: error_messages().pinboard_is_enable}}, else: {:ok}
  end

  @spec set_resource(Integer, Integer, Integer) :: {:ok, %Console{}} | {:error, String.t}
  def set_resource(member_id, session_topic_id, resource_id) do
    session_member = Repo.get!(SessionMember, member_id) |> Repo.preload(:account_user)
    resource = Repo.get!(Resource, resource_id)

    {:ok, console} = get(session_member.sessionId, session_topic_id)

    ConsolePermissions.can_set_resource(session_member)
    |> resource_validations(console, resource)
    |> case do
        {:ok} ->
          set_id_by_type(resource, :resource)
          |> update_console(console)
        {:error, reason} ->
          {:error, reason}
      end
  end

  @spec enable_pinboard(Integer, Integer, Boolean) :: {:ok, %Console{}} | {:error, String.t}
  def enable_pinboard(member_id, session_topic_id, enable) do
    session_member = Repo.get!(SessionMember, member_id) |> Repo.preload(:account_user)
    case ConsolePermissions.can_enable_pinboard(session_member) do
      {:ok} ->
        {:ok, console} = get(session_member.sessionId, session_topic_id)
        update_console(pinboard_setings(enable), console)
      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec pinboard_setings(Boolean.t) :: Map.t
  defp pinboard_setings(true), do:  %{audioId: nil, videoId: nil,  fileId: nil, pinboard: true }
  defp pinboard_setings(false), do:  %{pinboard: false }

  @spec has_enable_resource(%Console{}, %Resource{}) :: {:ok} | {:error, map}
  def has_enable_resource(%Console{audioId: nil, videoId: nil, fileId: nil }, _) do
    {:ok}
  end
  def has_enable_resource(console, resource) do
    field_id = get_field_from_type(resource.type)

    result=
      ~w(audioId videoId fileId)a
      |> Enum.reject(fn(x) -> x == field_id end)
      |> Enum.any?(fn(key) -> Map.get(console, key) |> is_integer end)

      if result do
        {:error, %{system: error_messages().other_resource_is_enable}}
      else
        {:ok}
      end
  end

  def find_enable_resource(%Console{audioId: id}) when is_integer(id), do: "audio"
  def find_enable_resource(%Console{videoId: id}) when is_integer(id), do: "video"
  def find_enable_resource(%Console{fileId: id}) when is_integer(id), do: "file"
  def find_enable_resource(_), do: "type not found"

  @spec tidy_up(list, String.t, integer) :: :ok
  def tidy_up(consoles, type, session_member_id) do
    Enum.each(consoles, fn console ->
      {:ok, new_console} = remove(session_member_id, console.sessionTopicId, type)
      data = ConsoleView.render("show.json", %{console: new_console})
      Endpoint.broadcast!( "session_topic:#{console.sessionTopicId}", "console", data)
    end)
    :ok
  end

  @spec set_mini_survey(Integer, Integer, Integer) :: {:ok, %Console{}} | {:error, String.t}
  def set_mini_survey(member_id, session_topic_id, mini_survey_id) do
    session_member = Repo.get!(SessionMember, member_id) |> Repo.preload(:account_user)
    case ConsolePermissions.can_enable_pinboard(session_member) do
      {:ok} ->
        {:ok, console} = get(session_member.sessionId, session_topic_id)
        mini_survey = Repo.get!(MiniSurvey, mini_survey_id)
        set_id_by_type(mini_survey, :mini_survey)
        |> update_console(console)
      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec remove(Integer, Integer, String.t) ::  {:ok, %Console{}} | {:error, String.t}
  def remove(member_id, session_topic_id, type) do
    session_member = Repo.get!(SessionMember, member_id) |> Repo.preload(:account_user)
    case ConsolePermissions.can_remove_resource(session_member) do
      {:ok} ->
        {:ok, console} = get(session_member.sessionId, session_topic_id)
        remove_id_by_type(type)
        |> update_console(console)
      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec update_console(Map, %Console{}) :: {:ok, %Console{}}
  defp update_console(changeset, console) do
    Console.changeset(console, changeset)
    |> Repo.update
  end

  @spec set_id_by_type(%MiniSurvey{}, Atom) :: Map
  defp set_id_by_type(mini_survey, :mini_survey) do
    Map.put(%{},get_field_from_type("miniSurvey"), mini_survey.id)
  end

  @spec set_id_by_type(%Resource{}, Atom) :: Map
  defp set_id_by_type(resource, :resource) do
    Map.put(%{}, get_field_from_type(resource.type), resource.id)
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
