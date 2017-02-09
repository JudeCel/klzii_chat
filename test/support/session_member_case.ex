defmodule KlziiChat.SessionMemberCase do
  use ExUnit.CaseTemplate
  alias KlziiChat.{Repo, User, SubscriptionPlan, Session, Account, SessionMember, ContactList, ContactListUser}

  setup do
    user = %User{ email: "dainis@gmail.com", encryptedPassword: "jee" } |> Repo.insert!
    user2 = %User{ email: "dainis_2@gmail.com", encryptedPassword: "pfff" } |> Repo.insert!
    user3 = %User{ email: "dainis_3@gmail.com", encryptedPassword: "pfff11" } |> Repo.insert!
    user4 = %User{ email: "dainis_4@gmail.com", encryptedPassword: "11111" } |> Repo.insert!
    admin_user = %User{email: "admin@gmail.com", encryptedPassword: "admin" } |> Repo.insert!

    admin_account = Repo.insert!(%Account{admin: true, name: "admin account", subdomain: "adminaccount"})
    account = Repo.insert!(%Account{name: "cool account", subdomain: "coolaccount"})

    account_user_admin = Ecto.build_assoc(admin_account, :account_users, user: admin_user,
      firstName: "Dainis",
      lastName: "Lapins",
      gender: "male",
      role: "admin",
      email: user.email
    ) |> Repo.insert! |>  Repo.preload(:account)

    account_user_account_manager = Ecto.build_assoc(account, :account_users, user: user,
      firstName: "Dainis",
      lastName: "Lapins",
      gender: "male",
      role: "accountManager",
      email: user.email
    ) |> Repo.insert! |>  Repo.preload(:account)

    account_user_participant = Ecto.build_assoc(account, :account_users, user: user2,
      firstName: "Dainis",
      lastName: "Lapins",
      gender: "male",
      role: "participant",
      email: user2.email
    ) |> Repo.insert! |>  Repo.preload(:account)

    account_user_participant_2 = Ecto.build_assoc(account, :account_users, user: user3,
      firstName: "Dainis",
      lastName: "Lapins",
      gender: "male",
      role: "participant",
      email: user3.email
    ) |> Repo.insert! |>  Repo.preload(:account)

    account_user_observer = Ecto.build_assoc(account, :account_users, user: user4,
      firstName: "Dainis",
      lastName: "Lapins",
      gender: "male",
      role: "observer",
      email: user4.email
    ) |> Repo.insert! |>  Repo.preload(:account)


    subscription_preference_data = %{
      sessionCount: 8,
      contactListCount: 4,
      recruiterContactListCount: 4,
      importDatabase: true,
      brandLogoAndCustomColors: true,
      contactListMemberCount: -1,
      accountUserCount: 5,
      exportContactListAndParticipantHistory: true,
      exportRecruiterSurveyData: true,
      accessKlzziForum: true,
      accessKlzziFocus: true,
      pinboardDisplay: true,
      canInviteObserversToSession: true,
      planSmsCount: 75,
      surveyCount: 20,
      discussionGuideTips: true,
      whiteboardFunctionality: true,
      uploadToGallery: true,
      reportingFunctions: true,
      availableOnTabletAndMobilePlatforms: true,
      customEmailInvitationAndReminderMessages: true,
      topicCount: -1,
      priority: 1,
      chargebeePlanId: "senior_yearly"
    }

    subscription_plan = Map.merge(%SubscriptionPlan{}, subscription_preference_data) |> Repo.insert!

     Ecto.build_assoc(account, :subscription,
      accountId: account.id,
      subscriptionPlanId: subscription_plan.id,
      planId: "some plan id",
      customerId: "some ID",
      subscriptionId: "some ID"
    ) |> Repo.insert!
      |> Ecto.build_assoc(:subscription_preference, data: subscription_preference_data)
      |> Repo.insert!

    contact_list = %ContactList{
      name: "participant list",
      role: "participant",
      accountId: account.id,
      editable: false,
      active: true,
      participantsFields: [],
      visibleFields: [],
      defaultFields: ~w(firstName lastName gender email postalAddress city state country postCode companyName landlineNumber mobil),
      customFields: ["something 1", "something 2", "something 3"],
    }|> Repo.insert!

    session = %Session{
      name: "cool session",
      startTime: Timex.now,
      endTime: Timex.shift(Timex.now, days: 7),
      accountId: account.id,
      timeZone: Timex.now |> Timex.format!( "%Z", :strftime),
      status: "open",
      type: "focus",
      participantListId: contact_list.id,
    } |> Repo.insert!

    [
      account_user_account_manager,
      account_user_participant,
      account_user_participant_2
    ] |> Enum.each(fn(account_user) ->
      %ContactListUser{
        contactListId: contact_list.id,
        accountId: account_user.account.id,
        userId: account_user.user.id,
        accountUserId: account_user.id,
        customFields: %{
          "something 1" => "#{account_user.firstName} something 1",
          "something 2" =>  "#{account_user.lastName} something 2",
          "something 3" => "#{account_user.role} something 3"}
        }|> Repo.insert!
    end)



    topic_1 = Ecto.build_assoc(account, :topics,
      name: "cool topic 1",
      boardMessage: "cool session topic 1"
    ) |> Repo.insert!
    session_topic_1 = Ecto.build_assoc(topic_1, :session_topics,
      session: session,
      name: "cool session topic 1",
      order: 1,
      boardMessage: "greeting message for cool session topic 1 !"
    ) |> Repo.insert!

    topic_2 = Ecto.build_assoc(account, :topics,
      name: "cool topic 2",
      boardMessage: "cool session topic 2"
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
      accountUserId: account_user_account_manager.id
    } |> Repo.insert!

    participant = %SessionMember{
      token: "==oasu8asnx",
      username: "cool member 2",
      sessionId: session.id,
      colour: "00000",
      role: "participant",
      accountUserId: account_user_participant.id
    } |> Repo.insert!

    participant2 = %SessionMember{
      token: "==oasu8asnx",
      username: "cool member",
      sessionId: session.id,
      colour: "00000",
      role: "participant",
      accountUserId: account_user_participant_2.id
    } |> Repo.insert!

    observer = %SessionMember{
      token: "==oasu8asnx",
      username: "cool member",
      sessionId: session.id,
      colour: "00000",
      role: "observer",
      accountUserId: account_user_observer.id
    } |> Repo.insert!

    {:ok,
      topic_1: topic_1,
      topic_2: topic_2,
      session_topic_1: session_topic_1,
      session_topic_2: session_topic_2,
      facilitator: facilitator,
      participant: participant,
      participant2: participant2,
      observer: observer,
      session: session,
      account_user_account_manager: account_user_account_manager,
      account_user_participant: account_user_participant,
      account_user_participant_2: account_user_participant_2,
      account_user_observer: account_user_observer,
      account: account,
      contact_list: contact_list,
      admin_account: admin_account,
      account_user_admin: account_user_admin,
      admin_user: admin_user
    }
  end
end
