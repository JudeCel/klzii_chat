defmodule KlziiChat.SessionChannelTest do
  use KlziiChat.ChannelCase

  # alias KlziiChat.SessionChannel
  #
  # setup do
  #   {:ok, _, socket} =
  #     socket("session_member", %{id: 1})
  #     |> subscribe_and_join(RoomChannel, "sessions:1")
  #
  #   {:ok, socket: socket}
  # end

  # test "ping replies with status ok", %{socket: socket} do
  #   ref = push socket, "ping", %{"hello" => "there"}
  #   assert_reply ref, :ok, %{"hello" => "there"}
  # end
  #
  # test "shout broadcasts to rooms:lobby", %{socket: socket} do
  #   push socket, "shout", %{"hello" => "all"}
  #   assert_broadcast "shout", %{"hello" => "all"}
  # end
  #
  # test "broadcasts are pushed to the client", %{socket: socket} do
  #   broadcast_from! socket, "broadcast", %{"some" => "data"}
  #   assert_push "broadcast", %{"some" => "data"}
  # end
end
