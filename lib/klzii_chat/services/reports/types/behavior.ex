defmodule KlziiChat.Services.Reports.Types.Behavior do
  @callback get_data(Map.t) :: {:ok, Map.t} | {:error, Map.t}
end
