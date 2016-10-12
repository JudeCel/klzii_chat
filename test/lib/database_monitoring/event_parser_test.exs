defmodule KlziiChat.DatabaseMonitoring.EventParserTest do
  use ExUnit.Case, async: true
  alias KlziiChat.DatabaseMonitoring.{EventParser}

  @id 3
  @payloade "{\"table\" : \"SessionTopics\", \"id\" : #{@id}, \"type\" : \"UPDATE\"}"

  setup do
    on_exit fn ->
      KlziiChat.DbCleanHelper.clean_up
    end
  end

  describe "succses"  do
    test "processe_event" do
      assert({:ok, "Running in Test ENV"} = EventParser.processe_event("table_update",@payloade))
    end

    test "decode_message" do
      assert(%{"id" => @id} = EventParser.decode_message("table_update", @payloade))
    end

    test "when event create_job" do
      pid = EventParser.create_job(%{"table" =>  "SessionTopics", "id" =>  @id})
      assert(is_pid(pid))
    end

    test "when unhandle event create_job" do
      message = EventParser.messages.errors.unhandle_event
      assert({:error, ^message} = EventParser.create_job(%{}))
    end
  end
end
