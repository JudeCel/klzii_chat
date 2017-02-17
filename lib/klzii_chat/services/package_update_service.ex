defmodule KlziiChat.Services.PackageUpdateService do
  def find do
    {yarn, _} = System.cmd("yarn", ["outdated", "--color"])
    {mix, _} = System.cmd("mix", ["hex.outdated"])

    { replace(yarn), replace(mix) }
  end

  def replace(string) do
    String.replace(string, "\e[1G", "")
    |> String.replace("\e[2K", "")
  end
end
