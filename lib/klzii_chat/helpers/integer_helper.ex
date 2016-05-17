defmodule KlziiChat.Helpers.IntegerHelper do
  def get_num(l_el) when is_integer(l_el), do: l_el

  def get_num(l_el) when is_bitstring(l_el) do
    String.to_integer(l_el)
  end
end
