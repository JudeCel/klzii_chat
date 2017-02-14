defmodule KlziiChat.Admin.LogsChannel do
  use KlziiChat.Web, :channel
  alias KlziiChat.{Repo}
  alias KlziiChat.Services.ConnectionLogService

  intercept ["new_log_entry"]

  def join("logs:pull", _, socket) do
    socket = set_default_filters(socket)
    case ConnectionLogService.history(get_filter(socket)) do
      {:ok, list} ->
        IO.inspect list
        {:ok, %{history: list, filters: get_filter(socket)}, socket}
      {:error, reason} ->
        {:error, reason}
    end
  end

  def handle_in("add_filter", %{"key" => key, "id" => id}, socket) do
    socket = add_filter(socket, key, id)
    case ConnectionLogService.history(get_filter(socket)) do
      {:ok, list} ->
          push(socket, "self_info", %{history: list, filters: get_filter(socket)})
      {:error, reason} ->
        {:error, reason}
    end
  end

  def handle_out("new_log_entry", payload, socket) do
    push socket, "new_log_entry", payload
    {:noreply, socket}
  end

  def get_filter(socket) do
    Map.get(socket.assigns, :filters, %{})
  end

  def add_filter(socket, key, id) do
    filters =
      get_filter(socket)
      |> Map.put(key, id)
    assign(socket, :filters, filters)
  end

  def set_default_filters(socket) do
    filtres =
      get_filter(socket)
      |> default_filters()
    assign(socket, :filters, filtres)
  end

  def default_filters(%{}) do
    %{"accountId" => nil, "accountUserId" => nil, "userId" => nil, "limit" => 100}
  end
  def default_filters(filters), do: filters
end
