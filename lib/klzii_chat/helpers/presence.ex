defmodule KlziiChat.Helpers.Presence do
  alias KlziiChat.{Presence}

  @spec topic_presences_ids(String.t) :: List.t
  def topic_presences_ids(session_topic_id) do
    Presence.list("session_topic:#{session_topic_id}") |> Map.keys |> Enum.map(&(String.to_integer(&1)))
  end

  @spec session_presences_ids(String.t) :: List.t
  def session_presences_ids(session_id) do
    Presence.list("sessions:#{session_id}") |> Map.keys |> Enum.map(&(String.to_integer(&1)))
  end
end
