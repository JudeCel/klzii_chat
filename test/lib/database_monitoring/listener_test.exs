defmodule KlziiChat.DatabaseMonitoring.ListenerTest do
  use ExUnit.Case, async: true
  alias KlziiChat.DatabaseMonitoring.{Listener}

  @id 3
  @session_id 3
  @payloade "{\"table\" : \"SessionTopics\", \"data\" : {\"id\": #{@id}, \"name\": \"Cool Session Topic1\", \"sessionId\":  #{@session_id} }, \"type\" : \"DELETE\"}"

  describe "succses"  do
    test "processe_event" do
      assert({:ok, "Running in Test ENV"} = Listener.processe_event("table_update", @payloade))
    end
  end
end
