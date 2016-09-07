defmodule KlziiChat.SessionTopicChannel do
  use KlziiChat.Web, :channel
  alias KlziiChat.Services.Permissions.Builder, as: PermissionsBuilder
  alias KlziiChat.Services.{MessageService, UnreadMessageService, ConsoleService,
    SessionTopicService, MiniSurveysService, PinboardResourceService, SessionMembersService}
  alias KlziiChat.{MessageView, Presence, Endpoint, ConsoleView, SessionTopicView, SessionMembersView, MiniSurveyView, PinboardResourceView}
  import(KlziiChat.Authorisations.Channels.SessionTopic, only: [authorized?: 2])
  import(KlziiChat.Helpers.SocketHelper, only: [get_session_member: 1])
  import KlziiChat.ErrorHelpers, only: [error_view: 1]


  @moduledoc """
    This Channel is only for Session Topic context brodcast and receive messages from session members
    History for specific session topic
  """

  intercept ["new_message", "update_message", "thumbs_up", "delete_pinboard_resource", "new_pinboard_resource"]

  def join("session_topic:" <> session_topic_id, _payload, socket) do
    if authorized?(socket, session_topic_id) do
      socket = assign(socket, :session_topic_id, String.to_integer(session_topic_id))
      send(self, :after_join)
      case MessageService.history(session_topic_id, get_session_member(socket)) do
        {:ok, history} ->
          {:ok, history, socket}
        {:error, reason} ->
          {:reply, {:error, error_view(reason)}, socket}
      end
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_info(:after_join, socket) do
    session_member = get_session_member(socket)
    {:ok, console} = ConsoleService.get(session_member.session_id, socket.assigns.session_topic_id)

    {:ok, _} = Presence.track(socket, (get_session_member(socket).id |> to_string), %{
      online_at: inspect(System.system_time(:seconds)),
      id: session_member.id,
      role: session_member.role
    })

    {:ok, member} = SessionMembersService.update_current_topic(session_member.id, socket.assigns.session_topic_id)
    Endpoint.broadcast!("sessions:#{session_member.session_id}", "update_member", member)

    UnreadMessageService.delete_unread_messages_for_topic(session_member.id, socket.assigns.session_topic_id)
    messages = UnreadMessageService.sync_state(session_member.id)
    Endpoint.broadcast!("sessions:#{session_member.session_id}", "unread_messages", messages)

    if console.pinboard do
      case PinboardResourceService.all(socket.assigns.session_topic_id) do
        {:ok, pinboard_resources} ->
          list = Enum.map(pinboard_resources, fn item->
            view = Phoenix.View.render_one(item, PinboardResourceView, "show.json", as: :pinboard_resource)
            permissions = PermissionsBuilder.pinboard_resource(get_session_member(socket), item)
            Map.put(view, :permissions, permissions)
          end)
          push socket, "console", ConsoleView.render("show.json", %{console: console})
          push socket, "pinboard_resources", %{list: list}
          {:noreply, socket}
        {:error, reason} ->
          {:reply, {:error, error_view(reason)}, socket}
      end
    else
      push socket, "console", ConsoleView.render("show.json", %{console: console})
      {:noreply, socket}
    end
  end

  def handle_in("board_message", payload, socket) do
    session_topic_id = socket.assigns.session_topic_id
    session_member = get_session_member(socket)
      case SessionTopicService.board_message(session_member.id, session_topic_id, payload) do
        {:ok, session_topic} ->
          broadcast!(socket, "board_message",  SessionTopicView.render("show.json", %{session_topic: session_topic}))
          {:reply, :ok, socket}
        {:error, reason} ->
          {:reply, {:error, error_view(reason)}, socket}
      end
  end

  def handle_in("create_mini_survey", payload, socket) do
    case MiniSurveysService.create(get_session_member(socket).id, socket.assigns.session_topic_id, payload) do
      {:ok, mini_survey} ->
        {:reply, {:ok, Phoenix.View.render_one(mini_survey, MiniSurveyView, "show.json", as: :mini_survey)}, socket}
      {:error, reason} ->
        {:reply, {:error, error_view(reason)}, socket}
    end
  end

  def handle_in("delete_mini_survey", %{"id" => id}, socket) do
    session_member = get_session_member(socket)
    case MiniSurveysService.delete(session_member.id, id) do
      {:ok, mini_survey} ->
        {:reply, {:ok, %{id: mini_survey.id}}, socket}
      {:error, reason} ->
        {:reply, {:error, error_view(reason)}, socket}
    end
  end

  def handle_in("answer_mini_survey", %{"id" => id, "answer" => answer}, socket) do
    case MiniSurveysService.create_answer(get_session_member(socket).id, id, answer) do
      {:ok, mini_survey} ->
        {:reply, {:ok, Phoenix.View.render_one(mini_survey, MiniSurveyView, "show_with_answer.json", as: :mini_survey)}, socket}
      {:error, reason} ->
        {:reply, {:error, error_view(reason)}, socket}
    end
  end

  def handle_in("show_mini_survey", %{"id" => id}, socket) do
    case MiniSurveysService.get_for_console(get_session_member(socket).id, id) do
      {:ok, mini_survey} ->
        {:reply, {:ok, Phoenix.View.render_one(mini_survey, MiniSurveyView, "show_with_answer.json", as: :mini_survey)}, socket}
      {:error, reason} ->
        {:reply, {:error, error_view(reason)}, socket}
    end
  end

  def handle_in("show_mini_survey_answers", %{"id" => id}, socket) do
    case MiniSurveysService.get_with_answers(id) do
      {:ok, mini_survey} ->
        {:reply, {:ok, Phoenix.View.render_one(mini_survey, MiniSurveyView, "show_with_answers.json", as: :mini_survey)}, socket}
      {:error, reason} ->
        {:reply, {:error, error_view(reason)}, socket}
    end
  end

  def handle_in("mini_surveys", _, socket) do
    case MiniSurveysService.get(socket.assigns.session_topic_id) do
      {:ok, mini_surveys} ->
        {:reply, {:ok, %{mini_surveys: Phoenix.View.render_many(mini_surveys, MiniSurveyView, "show.json", as: :mini_survey)}}, socket}
      {:error, reason} ->
        {:reply, {:error, error_view(reason)}, socket}
    end
  end

  def handle_in("set_console_resource", %{"id" => id}, socket) do
    case ConsoleService.set_resource(get_session_member(socket).id, socket.assigns.session_topic_id, id) do
      {:ok, console} ->
        broadcast! socket, "console",  ConsoleView.render("show.json", %{console: console})
        {:reply, :ok, socket}
      {:error, reason} ->
        {:reply, {:error, error_view(reason)}, socket}
    end
  end

  def handle_in("enable_pinboard", _, socket) do
    case ConsoleService.enable_pinboard(get_session_member(socket).id, socket.assigns.session_topic_id) do
      {:ok, console} ->
        broadcast! socket, "console",  ConsoleView.render("show.json", %{console: console})
        {:reply, :ok, socket}
      {:error, reason} ->
        {:reply, {:error, error_view(reason)}, socket}
    end
  end

  def handle_in("get_pinboard_resources", _, socket) do
      case PinboardResourceService.all(socket.assigns.session_topic_id) do
        {:ok, pinboard_resources} ->
          list = Enum.map(pinboard_resources, fn item->
            view = Phoenix.View.render_one(item, PinboardResourceView, "show.json", as: :pinboard_resource)
            permissions = PermissionsBuilder.pinboard_resource(get_session_member(socket), item)
            Map.put(view, :permissions, permissions)
          end)
          {:reply, {:ok, %{list: list}}, socket}
        {:error, reason} ->
          {:reply, {:error, error_view(reason)}, socket}
      end
  end

  def handle_in("delete_pinboard_resource", %{"id" => id}, socket) do
      case PinboardResourceService.delete(get_session_member(socket).id, id) do
        {:ok, pinboard_resource} ->
          broadcast! socket, "delete_pinboard_resource", pinboard_resource
          {:reply, :ok, socket}
        {:error, reason} ->
          {:reply, {:error, error_view(reason)}, socket}
      end
  end

  def handle_in("set_console_mini_survey", %{"id" => id}, socket) do
    case ConsoleService.set_mini_survey(get_session_member(socket).id, socket.assigns.session_topic_id, id) do
      {:ok, console} ->
        broadcast! socket, "console",  ConsoleView.render("show.json", %{console: console})
        {:reply, :ok, socket}
      {:error, reason} ->
        {:reply, {:error, error_view(reason)}, socket}
    end
  end

  def handle_in("remove_console_element", %{"type" => type}, socket) do
    case ConsoleService.remove(get_session_member(socket).id, socket.assigns.session_topic_id, type) do
      {:ok, console} ->
        broadcast! socket, "console",  ConsoleView.render("show.json", %{console: console})
        {:reply, :ok, socket}
      {:error, reason} ->
        {:reply, {:error, error_view(reason)}, socket}
    end
  end

  def handle_in("new_message", payload, socket) do
    session_topic_id = socket.assigns.session_topic_id
    session_member = get_session_member(socket)
      case MessageService.create_message(session_member, session_topic_id, payload) do
        {:ok, message} ->
          KlziiChat.BackgroundTasks.Message.new(message.id)
          broadcast!(socket, "new_message",  message)
          Endpoint.broadcast!("sessions:#{message.session_member.sessionId}", "update_member", SessionMembersView.render("member.json", member: message.session_member))
          {:reply, :ok, socket}
        {:error, reason} ->
          {:reply, {:error, error_view(reason)}, socket}
      end
  end

  def handle_in("delete_message", %{ "id" => id }, socket) do
    case MessageService.deleteById(get_session_member(socket), id) do
      {:ok, resp} ->
        session_member = get_session_member(socket)
        KlziiChat.BackgroundTasks.Message.delete(session_member.session_id, socket.assigns.session_topic_id)
        broadcast! socket, "delete_message", resp
        {:reply, :ok, socket}
      {:error, reason} ->
        {:reply, {:error, error_view(reason)}, socket}
    end
  end

  def handle_in("message_star", %{"id" => id}, socket) do
    session_member = get_session_member(socket)
    case MessageService.star(id, session_member) do
      {:ok, message} ->
        {:reply, {:ok, MessageView.render("show.json", %{message: message, member: session_member}) }, socket}
      {:error, reason} ->
        {:reply, {:error, error_view(reason)}, socket}
    end
  end

  def handle_in("thumbs_up", %{"id" => id}, socket) do
    case MessageService.thumbs_up(id, get_session_member(socket)) do
      {:ok, message} ->
        broadcast! socket, "update_message", message
        {:reply, :ok, socket}
      {:error, reason} ->
        {:reply, {:error, error_view(reason)}, socket}
    end
  end

  def handle_in("update_message", %{"id" => id, "body" => body, "emotion" => emotion}, socket) do
    case MessageService.update_message(id, body, emotion, get_session_member(socket)) do
      {:ok, message} ->
        broadcast! socket, "update_message", message
        {:reply, :ok, socket}
      {:error, reason} ->
        {:reply, {:error, error_view(reason)}, socket}
    end
  end

  def handle_out(message, payload, socket) when message in ["new_pinboard_resource", "delete_pinboard_resource"] do
    session_member = get_session_member(socket)
    view =
      Phoenix.View.render_one(payload, PinboardResourceView, "show.json", as: :pinboard_resource)
      |> Map.put(:permissions, PermissionsBuilder.pinboard_resource(session_member, payload))

    push socket, message, view
    {:noreply, socket}
  end

  def handle_out(message, payload, socket) do
    session_member = get_session_member(socket)
    push socket, message, MessageView.render("show.json", %{message: payload, member: session_member})
    {:noreply, socket}
  end
end
