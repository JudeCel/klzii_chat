defmodule KlziiChat.DatabaseMonitoring.ListenerTest do
  use ExUnit.Case, async: true
  alias KlziiChat.DatabaseMonitoring.{Listener}

  @id 3
  @payloade "{\"table\" : \"SessionTopics\", \"id\" : #{@id}, \"type\" : \"UPDATE\"}"

  describe "succses"  do
    test "processe_event" do
      assert({:ok, "Running in Test ENV"} = Listener.processe_event("table_update", @payloade))
    end
  end
end
