defmodule KlziiChat.Services.PackageUpdateService do
  def find do
    data =
      Task.async_stream([:elixir, :yarn, :node], &(dependencies(&1)) )
      |> Enum.to_list

    { :ok, data }
  end

  def dependencies(:elixir) do
    case System.cmd("mix", ["hex.outdated"]) do
      { data, 0 } ->
        { :ok, replace(data) }
      { error, _ } ->
        { :error, error }
    end
  end

  def dependencies(:yarn) do
    case System.cmd("yarn", ["outdated", "--color"]) do
      { data, 0 } ->
        { :ok, replace(data) }
      { error, _ } ->
        { :error, error }
    end
  end

  def dependencies(:node) do
    case node_dependencies do
      { :ok, res } ->
        { :ok, %{ "data" => data } } = Poison.decode(res)
        { :ok, replace(data) }
      { :error, error } ->
        { :error, error }
    end
  end

  def node_dependencies do
    %{ dashboard_url: dashboard } = Application.get_env(:klzii_chat, :resources_conf)
    case :hackney.get(<<dashboard <> "/updatePackages">>, [], <<>>, []) do
      { :ok, code, headers, client } ->
        :hackney.body(client)
      { :error, error } ->
        { :error, error }
    end
  end

  def replace(string) do
    String.replace(string, "\e[1G", "")
    |> String.replace("\e[2K", "")
  end
end
