defmodule KlziiChat.SessionMemberCase do
  use ExUnit.CaseTemplate
  alias KlziiChat.{Repo, User , Session, Account, SessionMember, BrandProjectPreference}


  setup do
    user = User.seedChangeset(%User{}, %{ email: "dainsi@gmail.com", encryptedPassword: "jee" }) |> Repo.insert!
    account = Account.changeset(%Account{}, %{name: "cool account"}) |> Repo.insert!
    account_user = Ecto.build_assoc(account, :account_users, user: user,
      firstName: "Dainis",
      lastName: "Lapins",
      gender: "male",
      role: "accountManager",
      email: user.email

    ) |> Repo.insert! |>  Repo.preload(:account)

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

    topic_1 = Ecto.build_assoc(account, :topics,
      name: "cool topic 1",
    ) |> Repo.insert!
    session_topic_1 = Ecto.build_assoc(topic_1, :session_topics,
      session: session,
      name: "cool session topic 1",
      order: 1,
      boardMessage: "greeting message for cool session topic 1 !"
    ) |> Repo.insert!

    topic_2 = Ecto.build_assoc(account, :topics,
      name: "cool topic 2",
    ) |> Repo.insert!

    session_topic_2 = Ecto.build_assoc(topic_2, :session_topics,
      session: session,
      name: "cool session topic 2",
      order: 2,
      boardMessage: "greeting message for cool session topic 2 !"
    ) |> Repo.insert!

    facilitator = %SessionMember{
      token: "oasu8asnx",
      username: "cool member",
      sessionId: session.id,
      role: "facilitator",
      colour: "00000",
      accountUserId: 1
    } |> Repo.insert!

    participant = %SessionMember{
      token: "==oasu8asnx",
      username: "cool member",
      sessionId: session.id,
      colour: "00000",
      role: "participant",
      accountUserId: 1
    } |> Repo.insert!

    {:ok,
      topic_1: topic_1,
      topic_2: topic_2,
      session_topic_1: session_topic_1,
      session_topic_2: session_topic_2,
      facilitator: facilitator,
      participant: participant,
      session: session,
      account_user: account_user,
    }
  end
end
