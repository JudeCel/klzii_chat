defmodule KlziiChat.Authorisations.Channels.SessionTest do
  use ExUnit.Case, async: true
  alias KlziiChat.Authorisations.Channels.Session

  test "Session authorisation succses #authorized?" do
    sesssion_id =  1
    session_member =  %{session_id: sesssion_id}
    socket =   Phoenix.Socket.assign(Phoenix.Socket.__struct__, :session_member, session_member)
    Session.authorized?(socket, sesssion_id) |> assert
  end

  test "Session authorisation fails #authorized?" do
    sesssion_id =  1
    session_member =  %{session_id: (sesssion_id + 1)}
    socket =   Phoenix.Socket.assign(Phoenix.Socket.__struct__, :session_member, session_member)
    Session.authorized?(socket, sesssion_id) |> refute
  end
end
