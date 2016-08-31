defmodule KlziiChat.AccountsCase do
  use ExUnit.CaseTemplate
  alias KlziiChat.{Repo, User, SubscriptionPlan, Account}

  setup do
    admin_user = %User{ email: "admin@gmail.com", encryptedPassword: "admin" } |> Repo.insert!
    user = %User{ email: "dainis@gmail.com", encryptedPassword: "jee" } |> Repo.insert!
    user2 = %User{ email: "dainis_2@gmail.com", encryptedPassword: "pfff" } |> Repo.insert!
    user3 = %User{ email: "dainis_3@gmail.com", encryptedPassword: "pfff11" } |> Repo.insert!

    admin_account = Repo.insert!(%Account{name: "admin account", subdomain: "adminaccount"})

    free_account = Repo.insert!(%Account{name: "free account", subdomain: "freeaccount"})
    core_account = Repo.insert!(%Account{name: "core account", subdomain: "coreaccount"})
    trial_account = Repo.insert!(%Account{name: "trial account", subdomain: "trialaccount"})

      trial = %{
        sessionCount: 1,
        contactListCount: 1,
        recruiterContactListCount: 1,
        importDatabase: true,
        brandLogoAndCustomColors: true,
        contactListMemberCount: -1,
        accountUserCount: 1,
        exportContactListAndParticipantHistory: false,
        exportRecruiterSurveyData: false,
        accessKlzziForum: true,
        accessKlzziFocus: true,
        canInviteObserversToSession: true,
        paidSmsCount: 20,
        planSmsCount: 20,
        discussionGuideTips: true,
        whiteboardFunctionality: true,
        uploadToGallery: true,
        reportingFunctions: true,
        availableOnTabletAndMobilePlatforms: true,
        customEmailInvitationAndReminderMessages: true,
        topicCount: -1,
        priority: -1,
        surveyCount: 1,
        secureSsl: true,
        chargebeePlanId: "free_trial"
      }

      free = %{
        sessionCount: 1,
        contactListCount: 1,
        recruiterContactListCount: 1,
        importDatabase: true,
        brandLogoAndCustomColors: false,
        contactListMemberCount: -1,
        accountUserCount: 1,
        exportContactListAndParticipantHistory: false,
        exportRecruiterSurveyData: false,
        accessKlzziForum: true,
        accessKlzziFocus: true,
        canInviteObserversToSession: false,
        paidSmsCount: 0,
        planSmsCount: 0,
        discussionGuideTips: true,
        whiteboardFunctionality: true,
        uploadToGallery: false,
        reportingFunctions: false,
        availableOnTabletAndMobilePlatforms: true,
        customEmailInvitationAndReminderMessages: true,
        topicCount: 5,
        priority: -1,
        surveyCount: 1,
        secureSsl: true,
        chargebeePlanId: "free_account"
      }

      core = %{
        sessionCount: 3,
        contactListCount: 2,
        recruiterContactListCount: 2,
        importDatabase: true,
        brandLogoAndCustomColors: true,
        contactListMemberCount: -1,
        accountUserCount: 2,
        exportContactListAndParticipantHistory: true,
        exportRecruiterSurveyData: true,
        accessKlzziForum: true,
        accessKlzziFocus: true,
        canInviteObserversToSession: true,
        paidSmsCount: 50,
        planSmsCount: 50,
        discussionGuideTips: true,
        whiteboardFunctionality: true,
        uploadToGallery: true,
        reportingFunctions: true,
        availableOnTabletAndMobilePlatforms: true,
        customEmailInvitationAndReminderMessages: true,
        topicCount: 20,
        priority: 2,
        related: 'core_yearly',
        surveyCount: 2,
        secureSsl: true,
        chargebeePlanId: "core_monthly"
      }

      none = nil

      plans = %{trial: trial, free: free, core: core, none: none}

      accounts = [
        {admin_user, admin_account, "admin", :none},
        {user, free_account, "accountManager", :free},
        {user2, core_account, "accountManager", :core},
        {user3, trial_account, "accountManager", :trial}
      ] |> Enum.reduce(%{}, fn ({user, account, role, plan}, acc) ->
        sub_plan = plans[plan]

        account_user = Ecto.build_assoc(account, :account_users, user: user,
          firstName: "Dainis",
          lastName: "Lapins",
          gender: "male",
          role: role,
          email: user.email
        ) |> Repo.insert! |>  Repo.preload(:account)

        if sub_plan do
          subscription_plan = Map.merge(%SubscriptionPlan{}, sub_plan) |> Repo.insert!

          {:ok, _} = Ecto.build_assoc(account_user.account, :subscription,
          accountId: account_user.account.id,
          subscriptionPlanId: subscription_plan.id,
          planId: sub_plan.chargebeePlanId,
          customerId: "some ID",
          subscriptionId: "some ID"
          ) |> Repo.insert!
          |> Ecto.build_assoc(:subscription_preference, data: sub_plan)
          |> Repo.insert
        end

        Map.put(acc, ("#{account_user.role}_#{plan}"), account_user)
        end )

    {:ok,
      accountManager_core: accounts["accountManager_core"],
      accountManager_free: accounts["accountManager_free"],
      accountManager_trial: accounts["accountManager_trial"],
      admin: accounts["admin_none"]
    }
  end
end
