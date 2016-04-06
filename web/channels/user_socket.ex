defmodule KlziiChat.UserSocket do
  use Phoenix.Socket
  import KlziiChat.Services.SessionMembersService, only: [find_by_token: 1]
  ## Channels
  channel "sessions:*", KlziiChat.SessionChannel
  channel "topics:*", KlziiChat.TopicChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll

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
    case find_by_token(token) do
      nil ->
        IO.inspect("Token not found")
        :error
      session_member ->
        {:ok, assign(socket, :session_member, session_member)}
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
end
