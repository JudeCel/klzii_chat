defmodule KlziiChat.SessionChannel do
  use KlziiChat.Web, :channel
  alias KlziiChat.Services.{SessionService, SessionMembersService, SessionReportingService, DirectMessageService}
  alias KlziiChat.Services.Permissions.Builder, as: PermissionsBuilder
  alias KlziiChat.Services.Permissions.SessionReporting, as: SessionReportingPermissions
  alias KlziiChat.{Presence, SessionMembersView, SessionTopicsReportView, DirectMessageView}
  import(KlziiChat.Authorisations.Channels.Session, only: [authorized?: 2])
  import(KlziiChat.Helpers.SocketHelper, only: [get_session_member: 1])

  @moduledoc """
    This Channel is only for session context
    Session Member information
    Global messages for session
  """

  intercept ["unread_messages", "session_topics_report_updated", "new_direct_message"]

  def join("sessions:" <> session_id, _, socket) do
    {session_id, _} = Integer.parse(session_id)
    if authorized?(socket, session_id) do
      send(self, :after_join)
      case SessionService.find_active(session_id) do
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
        permission_task = Task.async(fn ->
          {:ok, permissions_map} = PermissionsBuilder.subscription_permissions(session_member.id)
          push(socket, "self_info", SessionMembersView.render("current_member.json", member: session_member, permissions_map: permissions_map))
        end)

        broadcast(socket, "update_member", SessionMembersView.render("member.json", member: session_member))
        Task.await(permission_task)
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
    {:noreply, socket}
  end

  def handle_in("create_session_topic_report", %{"sessionTopicId" => session_topic_id, "format" => report_format, "type" => report_type, "facilitator" => include_facilitator}, socket) do
    case SessionReportingService.create_session_topic_report(socket.assigns.session_id, get_session_member(socket).id, session_topic_id, String.to_atom(report_format), String.to_atom(report_type), include_facilitator) do
      {:ok, session_topics_report} ->
        {:reply, {:ok, SessionTopicsReportView.render("show.json", %{report: session_topics_report})}, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  def handle_in("delete_session_topic_report", %{"id" => session_topic_report_id}, socket) do
    case SessionReportingService.delete_session_topic_report(session_topic_report_id, get_session_member(socket).id) do
      {:ok, _} ->
        {:reply, :ok, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  def handle_in("recreate_session_topic_report", %{"id" => session_topic_report_id}, socket) do
    case SessionReportingService.recreate_session_topic_report(session_topic_report_id, get_session_member(socket).id) do
      {:ok, session_topics_report} ->
        {:reply, {:ok, SessionTopicsReportView.render("show.json", %{report: session_topics_report})}, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  def handle_in("get_session_topics_reports", _, socket) do
  case SessionReportingService.get_session_topics_reports(socket.assigns.session_id, get_session_member(socket).id) do
      {:ok, session_topics_reports} ->
        {:reply, {:ok, SessionTopicsReportView.render("reports.json", %{reports: session_topics_reports})}, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  def handle_in("get_all_direct_messages", %{ "recieverId" => other_member_id, "page" => page }, socket) do
    current_member_id = get_session_member(socket).id

    messages = DirectMessageService.get_all_direct_messages(current_member_id, other_member_id, page)
    {:reply, {:ok, %{ messages: DirectMessageView.render("messages.json", messages: messages, prevPage: page) }}, socket}
  end

  def handle_in("create_direct_message", %{ "recieverId" => other_member_id, "text" => text }, socket) do
    current_member = get_session_member(socket)

    { :ok, message } = DirectMessageService.create_message(current_member.session_id, %{ "recieverId" => other_member_id, "text" => text, "senderId" => current_member.id })
    encoded = DirectMessageView.render("show.json", message: message);

    key = message.recieverId |> to_string
    broadcast(socket, "new_direct_message", %{ key => encoded })
    {:reply, { :ok, %{ message: encoded } }, socket}
  end

  def handle_in("set_read_direct_messages", %{ "senderId" => other_member_id }, socket) do
    current_member = get_session_member(socket)

    :ok = DirectMessageService.set_all_messages_read(current_member.id, other_member_id)
    count = DirectMessageService.get_unread_count(current_member.id)
    {:reply, { :ok, %{ count: count } }, socket}
  end

  def handle_in("get_last_messages", _, socket) do
    current_member = get_session_member(socket)
    {:reply, { :ok, %{ messages: DirectMessageService.get_last_messages(current_member.id) } }, socket}
  end

  def handle_in("get_unread_count", _, socket) do
    current_member = get_session_member(socket)
    count = DirectMessageService.get_unread_count(current_member.id)
    {:reply, { :ok, %{ count: count } }, socket}
  end

  def handle_out("new_direct_message", payload, socket) do
    id = get_session_member(socket).id |> to_string
    case Map.get(payload, id, nil) do
      map when is_map(map) ->
        push socket, "new_direct_message", map
      nil ->
        nil
    end
    {:noreply, socket}
  end

  def handle_out("session_topics_report_updated", payload, socket) do
    if SessionReportingPermissions.can_create_report(get_session_member(socket)) do
      push socket, "session_topics_report_updated", SessionTopicsReportView.render("show.json", %{report: payload})
    end
    {:noreply, socket}
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
end
