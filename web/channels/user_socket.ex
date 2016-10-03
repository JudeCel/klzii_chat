defmodule KlziiChat.UserSocket do
  use Phoenix.Socket
  import Guardian.Phoenix.Socket
  alias KlziiChat.Services.Permissions.Builder, as: PermissionsBuilder
  ## Channels
  channel "sessions:*", KlziiChat.SessionChannel
  channel "session_topic:*", KlziiChat.SessionTopicChannel
  channel "whiteboard:*", KlziiChat.WhiteboardChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  transport :longpoll, Phoenix.Transports.LongPoll

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  def connect(%{"token" => token}, socket) do
    case sign_in(socket, token) do
      {:ok, authed_socket, _guardian_params} ->
        {:ok, assign(authed_socket, :session_member, get_current_resource(authed_socket) )}
      _ ->
       {:error, "Token not found"}
    end
  end

  def connect(_params, _socket), do: :error
  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "users_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     KlziiChat.Endpoint.broadcast("users_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(socket), do: "session_member_socket:#{socket.assigns.session_member.id}"

  defp get_current_resource(socket) do
    member = current_resource(socket)
    {:ok, permissions_map} = PermissionsBuilder.session_member_permissions(member.session_member.id)
    Phoenix.View.render(KlziiChat.SessionMembersView, "current_member.json", member: member.session_member, permissions_map: permissions_map)
  end
end
