defmodule KlziiChat.SessionChannelTest do
  use KlziiChat.ChannelCase
  alias KlziiChat.SessionChannel
  alias KlziiChat.{Repo, Session, Account}

  setup do
    current_member = %{ id: 1}
    account = Account.changeset(%Account{}, %{name: "cool account"}) |> Repo.insert!
    session = %Session{
      name: "cool session",
      start_time: Ecto.DateTime.cast!("2016-01-17T14:00:00.030Z"),
      end_time: Ecto.DateTime.cast!("2020-04-17T14:00:00.030Z"),
      accountId: account.id,
      active: true
    } |> Repo.insert!

    {:ok, _, socket} =
      socket(:session_member, %{session_member: current_member})
        |> subscribe_and_join(SessionChannel, "sessions:" <> Integer.to_string(session.id))

    {:ok, socket: socket, current_member: current_member}
  end

  test "after join get members" do
    assert_push "members", %{
      "facilitator" => %{},
      "observer" => [],
      "participant" => []
    }
  end

  test "after join get self info" do
    assert_push "self_info", current_member
  end

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
