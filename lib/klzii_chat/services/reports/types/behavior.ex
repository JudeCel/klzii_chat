defmodule KlziiChat.Services.Reports.Types.Behavior do

  @callback get_data(Map.t) :: {:ok, Map.t} | {:error, Map.t}
  @callback header_title(Map.t) :: String.t
  @callback get_session(Map.t) :: {:ok, Map.t} | {:error, Map.t}

end
