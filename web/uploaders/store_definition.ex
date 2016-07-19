defmodule KlziiChat.Uploaders.StoreDefinition do
  defmacro __using__(_) do
    quote do
      def __storage do
        case Mix.env do
          :prod ->
            Arc.Storage.S3
          _ ->
            Arc.Storage.Local
        end
      end

      def storage_dir(_, {_file, scope}) do
        case Mix.env do
          :prod ->
          storage_dir_path(scope)
          _ ->
            "priv/static/uploads/#{storage_dir_path(scope)}"
        end
      end

      # Override the persisted filenames:
      def filename(version, {_file, scope}) do
        str = "#{version}_#{scope.name}"
        Regex.replace(~r/( |-)/, str, "")
      end
      def filename(version, _), do: version

      defp storage_dir_path(scope) do
        "#{to_string(Mix.env)}/#{scope.type}/#{scope.accountId}/#{scope.id}/"
      end
    end
  end
end
