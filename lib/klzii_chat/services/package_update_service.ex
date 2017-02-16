defmodule KlziiChat.Services.PackageUpdateService do
  def find do
    {yarn, _} = System.cmd("yarn", ["outdated"])
    {mix, _} = System.cmd("mix", ["hex.outdated"])

    { replace(yarn), replace(mix) }
  end

  def replace(string) do
    String.replace(string, " ", "&nbsp;")
    |> String.replace("\n", "<br />")
  end
end
