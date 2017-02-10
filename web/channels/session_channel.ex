defmodule KlziiChat.SessionChannel do
  use KlziiChat.Web, :channel
  alias KlziiChat.Services.{SessionService, SessionMembersService, SessionReportingService, DirectMessageService}
  alias KlziiChat.Services.Permissions.SessionReporting, as: SessionReportingPermissions
  alias KlziiChat.{Presence, SessionMembersView, SessionTopicsReportView, DirectMessageView, ReportView}
  import(KlziiChat.Authorisations.Channels.Session, only: [authorized?: 2])
  import(KlziiChat.Helpers.SocketHelper, only: [get_session_member: 1, track: 1])
  import KlziiChat.ErrorHelpers, only: [error_view: 1]


  @moduledoc """
    This Channel is only for session context
    Session Member information
    Global messages for session
  """

  intercept ["unread_messages", "session_topics_report_updated",
    "new_direct_message", "update_member", "read_message",
    "self_info"]

  def join("sessions:" <> session_id, _, socket) do
    {session_id, _} = Integer.parse(session_id)
    case authorized?(socket, session_id) do
      {:ok} ->
        send(self(), :after_join)
        case SessionService.find_active(session_id) do
          {:ok, session} ->
            {:ok, session, assign(socket, :session_id, session_id)}
          {:error, reason} ->
           {:error, %{reason: reason}}
        end
      {:error, reason} ->
        {:error, reason}
    end
  end

  def handle_info(:after_join, socket) do
    session_member = get_session_member(socket)
    case SessionMembersService.by_session(socket.assigns.session_id) do
      {:ok, members} ->
        push socket, "members", members
      {:error, reason} ->
        push(socket, "error_message", reason)
    end

    {:ok, _} = track(socket)

    case SessionReportingPermissions.can_get_reports(get_session_member(socket)) do
      {:ok} ->
        case SessionReportingService.get_session_contact_list(socket.assigns.session_id) do
          {:ok, session} ->
            mapStruct =  ReportView.render("map_struct.json", %{session: session})
            push(socket, "contact_list_map_struct", %{mapStruct: mapStruct})
          {:error, reason} ->
            push(socket, "error_message", reason)
        end
      {:error, _} ->
        nil
    end

    push socket, "presence_state", Presence.list(socket)
    push(socket, "self_info", session_member)
    send(self(), :jwt_token)
    {:noreply, socket}
  end
  def handle_info(:jwt_token, socket) do
    session_member = get_session_member(socket)
    { :ok, jwt, _encoded_claims } =  Guardian.encode_and_sign(%KlziiChat.AccountUser{id: session_member.account_user_id}, :token )
    send(self(), :resources_conf)
    push(socket, "jwt_token", %{token: jwt})
    {:noreply, socket}
  end
  def handle_info(:resources_conf, socket) do
    {:ok, resource_conf} = Application.fetch_env(:klzii_chat, :resources_conf)
    push(socket, "resources_conf", %{resources_conf: resource_conf})
    {:noreply, socket}
  end

  def handle_in("update_member", params, socket) do
    case SessionMembersService.update_member(get_session_member(socket).id, params) do
      {:ok, session_member} ->
        socket = assign(socket, :session_member, Map.merge(get_session_member(socket), SessionMembersView.render("member.json", member: session_member )))
        push(socket, "self_info", get_session_member(socket))
        broadcast(socket, "update_member", session_member)
        {:noreply, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  def handle_in("create_session_topic_report", payload, socket) do
    case SessionReportingService.create_report(get_session_member(socket).id, payload) do
      {:ok, report} ->
        {:reply, {:ok, SessionTopicsReportView.render("show.json", %{report: report})}, socket}
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
    case SessionReportingService.recreate_report(session_topic_report_id, get_session_member(socket).id) do
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

    DirectMessageService.create_message(current_member.session_id, %{ "recieverId" => other_member_id, "text" => text, "senderId" => current_member.id })
    |> case  do
      { :ok, message } ->
        encoded = DirectMessageView.render("show.json", message: message)
        key = message.recieverId |> to_string
        broadcast(socket, "new_direct_message", %{ key => encoded })
        KlziiChat.BackgroundTasks.Message.send_notification(other_member_id, current_member.session_id, Presence.list(socket), "private_message")
        {:reply, { :ok, %{ message: encoded } }, socket}
      { :error, reason} ->
        {:reply, {:error, error_view(reason)}, socket}
      end
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

  def handle_out("update_member", payload, socket) do
    push socket, "update_member", SessionMembersView.render("member.json", %{member: payload})
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

  def handle_out("read_message", payload, socket) do
    session_member = get_session_member(socket)
    if session_member.id == payload.session_member_id do
      id = session_member.id |> to_string
      case Map.get(payload.messages, id, nil) do
        map when is_map(map) ->
          push socket, "unread_messages", map
        nil ->
          nil
      end
    end
    {:noreply, socket}
  end

  def handle_out("self_info", payload, socket) do
    session_member = get_session_member(socket)
    if session_member.id == payload.id do
      push socket, "self_info", payload
    end
    {:noreply, socket}
  end

end
