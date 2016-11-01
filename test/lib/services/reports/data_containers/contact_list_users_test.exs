defmodule KlziiChat.Services.Report.DataContainers.ContactListUsersTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.Report.DataContainers.ContactListUsers

  setup %{session: session} do
    preload_session =
      Repo.preload(session, [:account, :brand_logo, :brand_project_preference, [participant_list:  [contact_list_users: [:account_user]]] ])
      |> Phoenix.View.render_one(KlziiChat.SessionView, "report.json", as: :session)
      {:ok, preload_session: preload_session}
  end

  describe "prepare conteiner data" do
    test "set path to data", %{preload_session: preload_session} do
      account_user_keys =
        preload_session.participant_list.contact_list_users
        |> Enum.map(fn (contact_list_user) -> get_in(contact_list_user, [:account_user, "id"]) |> to_string end)

      keys =
        ContactListUsers.prepare_data(preload_session.participant_list)
        |> Map.keys

      assert(keys == account_user_keys)
    end
  end

  describe "find element in map" do
    setup do
      data = %{ "14070" => %{account_user: %{"email" => "dainis@gmail.com",
                    "firstName" => "Dainis", "gender" => "male", "lastName" => "Lapins",
                    "role" => "accountManager"},
                  customFields: %{"something 1" => "Dainis something 1",
                    "something 2" => "Lapins something 2",
                    "something 3" => "accountManager something 3"}, id: 8173},
                "14071" => %{account_user: %{"email" => "dainis_2@gmail.com",
                    "firstName" => "Dainis", "gender" => "male", "lastName" => "Lapins",
                    "role" => "participant"},
                  customFields: %{"something 1" => "Dainis something 1",
                    "something 2" => "Lapins something 2",
                    "something 3" => "participant something 3"}, id: 8174},
                "14072" => %{account_user: %{"email" => "dainis_3@gmail.com",
                    "firstName" => "Dainis", "gender" => "male", "lastName" => "Lapins",
                    "role" => "participant"},
                  customFields: %{"something 1" => "Dainis something 1",
                    "something 2" => "Lapins something 2",
                    "something 3" => "participant something 3"}, id: 8175}}
      {:ok, container_state: data}
    end

    test "find default key string/atom", %{container_state: container_state} do
      value = get_in(container_state, ["14071", :account_user, "firstName"])
      assert({:ok, value} == ContactListUsers.find_key(container_state, "firstName", 14071))
      assert({:ok, value} == ContactListUsers.find_key(container_state, :firstName, "14071"))
    end

    test "find custom key", %{container_state: container_state} do
      value = get_in(container_state, ["14071", :customFields, "something 2"])
      assert({:ok, value} == ContactListUsers.find_key(container_state, "something 2", "14072"))
    end

    test "when try private", %{container_state: container_state} do
      assert({:error, _} = ContactListUsers.find_key(container_state, "email", "14072"))
    end
  end
end
