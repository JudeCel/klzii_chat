defmodule KlziiChat.Services.Permissions.SessionTopicTest do
  use ExUnit.Case, async: true
  alias  KlziiChat.Services.Permissions.SessionTopic

  test "can_board_message" do
    member = %{role: "facilitator"}
    SessionTopic.can_board_message(member) |> assert
  end
end
