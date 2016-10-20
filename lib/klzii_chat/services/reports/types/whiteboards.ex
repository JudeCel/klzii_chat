defmodule KlziiChat.Services.Reports.Types.Whiteboards do
  @behaviour KlziiChat.Services.Reports.Types.Behavior

  @spec get_data(Map.t) :: {:ok, Map.t} | {:error, Map.t}
  def get_data(report) do
    {:ok, %{}}
  end
end
