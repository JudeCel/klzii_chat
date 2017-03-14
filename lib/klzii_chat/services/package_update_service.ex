defmodule KlziiChat.Services.PackageUpdateService do
  def find do
    Task.async_stream([:elixir, :yarn, :node], &(dependencies(&1)) )
    |> Enum.to_list
    |> Enum.map(fn({ _, { _, value } }) -> value end)
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
    case node_dependencies() do
      { :ok, res } ->
        case Poison.decode(res) do
          { :ok, %{ "data" => data } } ->
            { :ok, replace(data) }
          { :ok, %{ "error" => error } } ->
            { :error, replace(error) }
        end
      { :error, error } ->
        { :error, error }
    end
  end

  def node_dependencies do
    %{ dashboard_url: dashboard } = Application.get_env(:klzii_chat, :resources_conf)
    # Temp token
    case :hackney.get(<<dashboard <> "/updatePackages?token=securityToken123">>, [], <<>>, []) do
      { :ok, _, _, client } ->
        :hackney.body(client)
      { :error, error } ->
        { :error, Atom.to_string(error) }
    end
  end

  def replace(string) do
    String.replace(string, "\e[1G", "")
    |> String.replace("\e[2K", "")
  end
end
