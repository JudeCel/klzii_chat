defmodule KlziiChat.SessionMemberCase do
  use ExUnit.CaseTemplate
  alias KlziiChat.{User, AccountUser, Repo, Session, Account, SessionMember, BrandProjectPreference}


  setup do
    user = User.seedChangeset(%User{}, %{ email: "dainsi@gmail.com", encryptedPassword: "jee" }) |> Repo.insert!
    account = Account.changeset(%Account{}, %{name: "cool account"}) |> Repo.insert!
    account_user = Ecto.build_assoc(account, :account_users, user: user,
      firstName: "Dainis",
      lastName: "Lapins",
      gender: "male",
      role: "accountManager",
      email: user.email

    ) |> Repo.insert!

    brand_project_preference = BrandProjectPreference.changeset(
      %BrandProjectPreference{},
        %{
          name: "cool BrandProjectPreference",
          colours: %{},
          accountId:  account.id
        }
    )|> Repo.insert!


    session = %Session{
      name: "cool session",
      startTime: Ecto.DateTime.cast!("2016-01-17T14:00:00.030Z"),
      endTime: Ecto.DateTime.cast!("2020-04-17T14:00:00.030Z"),
      accountId: account.id,
      brandProjectPreferenceId: brand_project_preference.id,
      active: true
    } |> Repo.insert!

    member = %SessionMember{
      token: "oasu8asnx",
      username: "cool member",
      sessionId: session.id,
      role: "facilitator",
      colour: "00000",
      accountUserId: 1
    } |> Repo.insert!

    member2 = %SessionMember{
      token: "==oasu8asnx",
      username: "cool member",
      sessionId: session.id,
      colour: "00000",
      role: "participant",
      accountUserId: 1
    } |> Repo.insert!

    {:ok, account_user: account_user, session: session, session: session, member: member, member2: member2 }
  end
end
