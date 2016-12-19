defmodule KlziiChat.Dashboard.SessionsBuilderChannelTest do
  use KlziiChat.{ChannelCase, SessionMemberCase}
  alias KlziiChat.{Repo}
  alias KlziiChat.Dashboard.{SessionsBuilderChannel, UserSocket}

  setup %{session: session, account_user_account_manager: account_user_account_manager} do
    Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})
    channel_name =  "sessionsBuilder:" <> Integer.to_string(session.id)
    { :ok, jwt1, _encoded_claims } =  Guardian.encode_and_sign(account_user_account_manager)

    {:ok, socket} = connect(UserSocket, %{"token" => jwt1})
    {:ok, socket: socket, channel_name: channel_name}
  end

  test "when unauthorized", %{socket: socket, channel_name: channel_name} do
    assert({:error, %{reason: "unauthorized"}} == join(socket, SessionsBuilderChannel, channel_name <> "2233"))
  end

  test "after join events", %{socket: socket, account_user_account_manager: account_user_account_manager, channel_name: channel_name} do
    {:ok, _, socket} =
      join(socket, SessionsBuilderChannel, channel_name)
    assert(account_user_account_manager.id == socket.assigns.account_user.id)
  end
end
