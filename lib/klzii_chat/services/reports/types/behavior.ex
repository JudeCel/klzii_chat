defmodule KlziiChat.Services.Reports.Types.Behavior do

  @callback get_data(Map.t) :: {:ok, Map.t} | {:error, Map.t}
  @callback get_header_title(Map.t, Map.t) :: {:ok, String.t}
  @callback default_fields() :: List.t
  @callback get_session(Map.t) :: {:ok, Map.t} | {:error, Map.t}
  @callback get_session_topics(Map.t) :: {:ok, Map.t}
end
