defmodule KlziiChat.SessionChannel do
  use KlziiChat.Web, :channel
  alias KlziiChat.Services.{SessionService, SessionMembersService, SessionReportingService}
  alias KlziiChat.Services.Permissions.Builder, as: PermissionsBuilder
  alias KlziiChat.{Presence, SessionMembersView}
  import(KlziiChat.Authorisations.Channels.Session, only: [authorized?: 2])
  import(KlziiChat.Helpers.SocketHelper, only: [get_session_member: 1])

  @moduledoc """
    This Channel is only for session context
    Session Member information
    Global messages for session
  """

  intercept ["unread_messages", "session_topics_report_updated"]

  def join("sessions:" <> session_id, _, socket) do
    {session_id, _} = Integer.parse(session_id)
    if authorized?(socket, session_id) do
      send(self, :after_join)
      case SessionService.find(session_id) do
        {:ok, session} ->
          {:ok, session, assign(socket, :session_id, session_id)}
        {:error, reason} ->
          {:error, %{reason: reason}}
      end
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_info(:after_join, socket) do
    case SessionMembersService.by_session(socket.assigns.session_id) do
      {:ok, members} ->
        push socket, "members", members
      {:error, reason} ->
        {:error, %{reason: reason}}
    end

      {:ok, _} = Presence.track(socket, (get_session_member(socket).id |> to_string), %{
        online_at: inspect(System.system_time(:seconds)),
        id: get_session_member(socket).id,
        role: get_session_member(socket).role
      })
      push socket, "presence_state", Presence.list(socket)
      push(socket, "self_info", get_session_member(socket))
    {:noreply, socket}
  end

  def handle_in("update_member", params, socket) do
    case SessionMembersService.update_member(get_session_member(socket).id, params) do
      {:ok, session_member} ->
        permision_task = Task.async(fn ->
          permissions = PermissionsBuilder.member_permissions(session_member.id)
          push(socket, "self_info", SessionMembersView.render("current_member.json", member: session_member, permissions_map: permissions))
        end)

        broadcast(socket, "update_member", SessionMembersView.render("member.json", member: session_member))
        Task.await(permision_task)
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
    {:noreply, socket}
  end

  def handle_in("create_session_topic_report", %{"sessionTopicId" => session_topic_id, "format" => report_format, "type" => report_type, "facilitator" => include_facilitator}, socket) do
      session_member = get_session_member(socket)
      case SessionReportingService.create_session_topic_report(socket.assigns.session_id, session_member.id, session_topic_id, String.to_atom(report_format), String.to_atom(report_type), include_facilitator) do
      {:ok, session_topics_report} ->
        {:reply, {:ok, session_topics_report}, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
      end
  end

  def handle_in("remove_session_topic_report", %{"sessionTopicReportId" => session_topic_report_id}, socket) do

  end

  def handle_in("get_session_topics_reports", _params, socket) do
    session_member_id = get_session_member(socket).id

    case SessionReportingService.get_session_topics_reports(session_member_id) do
      {:ok, session_topics_reports} ->
        {:reply, {:ok, session_topics_reports}, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  def handle_out("unread_messages", payload, socket) do
    id = get_session_member(socket).id |> to_string
    case Map.get(payload, id, nil) do
      map when is_map(map) ->
        push socket, "unread_messages", map
      nil ->
        nil
    end
    {:noreply, socket}
  end

  def handle_out("session_topics_report_updated", payload, socket) do
    case get_session_member(socket).role do
      "facilitator" -> push socket, "session_topics_report_updated", payload
      _ -> nil
    end
    {:noreply, socket}
  end

end
