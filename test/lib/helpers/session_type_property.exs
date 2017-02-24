defmodule KlziiChat.Helpers.SessionTypePropertyTest do
  use ExUnit.Case, async: true
  alias KlziiChat.Helpers.SessionTypeProperty

  test "return session type property" do
    session = %{session_type: %{properties: %{"features" => %{"pinboard" => %{"enabled" => true }}}}}
    assert(SessionTypeProperty.get_value(session, ["features", "pinboard", "enabled"]))
  end
end
