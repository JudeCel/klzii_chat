defmodule KlziiChat.Services.Report.DataContainers.ContactListUsers do
  @privateKeys ["lastName", "email", "mobil", "companyName", "postalAddress", "landlineNumber"]

  def start_link(data) when is_map(data) do
    Agent.start_link(fn -> prepare_data(data) end)
  end
  def start_link(_), do: Agent.start_link(fn -> %{} end)

  def get_key(agent, key, id) do
    Agent.get(agent, fn state -> find_key(state, key, id) end)
  end

  def find_key(state, key, id) do
    with {:ok} <- validate_key(key),
         {:ok, value} <- get_from_state(state, key, id),
    do: {:ok, value}
  end

  def get_from_state(state, key, id) do
    string_id = to_string(id)
    string_key = to_string(key)
    account_user_list = [string_id, :account_user, string_key]
    custom_fields_list = [string_id, :customFields, string_key]
    (get_in(state, account_user_list) || get_in(state, custom_fields_list))
    |>  case do
        nil -> {:ok, nil}
        value -> {:ok, value }
      end
  end

  def prepare_data(data) do
    for item <- data.contact_list_users, into: %{} do
      case get_in(item, [:account_user, "id"]) do
        nil -> raise("Account user is missing for contact list with id: #{item.id}")
        id ->
          {to_string(id), item}
      end
    end
  end

  def validate_key(key) do
  Enum.member?(@privateKeys, to_string(key))
    |> case do
        true -> {:error, "This key is private "}
        false -> {:ok}
      end
  end
end
