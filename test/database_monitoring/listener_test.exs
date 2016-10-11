defmodule KlziiChat.DatabaseMonitoring.ListenerTest do
  use ExUnit.Case, async: true
  alias KlziiChat.DatabaseMonitoring.{Listener}

  @id 3
  @payloade "{\"table\" : \"SessionTopics\", \"id\" : #{@id}, \"type\" : \"UPDATE\"}"

  setup do
    on_exit fn ->
      KlziiChat.DbCleanHelper.clean_up
    end
  end

  describe "succses"  do
    test "processe_event" do
      assert({:ok, "Running in Test ENV"} = Listener.processe_event("table_update",@payloade))
    end

    test "decode_message" do
      assert(%{"id" => @id} = Listener.decode_message("table_update", @payloade))
    end

    test "when event create_job" do
      assert({:ok, _} = Listener.create_job(%{"table" =>  "SessionTopics", "id" =>  @id}))
    end

    test "when unhandle event create_job" do
      message = Listener.messages.errors.unhandle_event
      assert({:error, ^message} = Listener.create_job(%{}))
    end
  end
end
