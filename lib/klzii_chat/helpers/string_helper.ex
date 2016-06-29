defmodule KlziiChat.Helpers.StringHelper do
  def double_quote(string) when is_bitstring(string) do
    ~s("#{String.replace(string, ~s("), ~s(""))}")
  end
end
