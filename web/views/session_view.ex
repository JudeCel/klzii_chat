defmodule KlziiChat.SessionView do
  use KlziiChat.Web, :view
  alias KlziiChat.{SessionTopicView, ResourceView, AccountView, ContactListView, SessionSurveyView}

  def render("session.json", %{session: session}) do
    %{id: session.id,
      name: session.name,
      type: session.type,
      anonymous: session.anonymous,
      startTime: session.startTime,
      endTime: session.endTime,
      colours: brand_project_preference(session.brand_project_preference),
      brand_logo: brand_logo(session.brand_logo),
      session_surveys: render_many(session_surveys(session.session_surveys), SessionSurveyView, "show.json", as: :session_survey),
      session_topics: render_many(session_topics(session.session_topics), SessionTopicView, "show.json", as: :session_topic),
      timeZone: session.timeZone,
      account: render_one(account(session.account), AccountView, "show.json", as: :account)
    }
  end

  def render("report.json", %{session: session}) do
    %{id: session.id,
      name: session.name,
      type: session.type,
      startTime: session.startTime,
      endTime: session.endTime,
      anonymous: session.anonymous,
      colours: brand_project_preference(session.brand_project_preference),
      brand_logo: brand_logo(session.brand_logo),
      session_topics: render_many(session_topics(session.session_topics), SessionTopicView, "report.json", as: :session_topic),
      participant_list: render_one(participant_list(session.participant_list), ContactListView, "report.json", as: :contact_list),
      timeZone: session.timeZone,
      account: render_one(account(session.account), AccountView, "show.json", as: :account)
    }
  end
  def render("report_statistic.json", %{session: session}) do
    %{id: session.id,
      name: session.name,
      type: session.type,
      anonymous: session.anonymous,
      participant_list: render_one(participant_list(session.participant_list), ContactListView, "report.json", as: :contact_list),
      session_topics: render_many(session_topics(session.session_topics), SessionTopicView, "report_statistic.json", as: :session_topic),
      session_members: render_many(session.session_members, KlziiChat.SessionMembersView, "report_statistic.json", as: :member),
      account: render_one(account(session.account), AccountView, "show.json", as: :account)
    }
  end

  defp brand_project_preference(brand_project_preference) when is_map(brand_project_preference), do: brand_project_preference.colours
  defp brand_project_preference(_) do
    %{
       browserBackground: "#EFEFEF",
       mainBackground: "#FFFFFF",
       mainBorder: "#F0E935",
       font: "#58595B",
       headerButton: "#4CBFE9",
       consoleButtonActive: "#4CB649",
    }
  end

  defp session_topics(%{__struct__: Ecto.Association.NotLoaded}), do: []
  defp session_topics(topics), do: topics

  defp account(%{__struct__: Ecto.Association.NotLoaded}), do: nil
  defp account(account), do: account

  defp session_surveys(%{__struct__: Ecto.Association.NotLoaded}), do: []
  defp session_surveys(session_surveys), do: session_surveys

  defp participant_list(%{__struct__: Ecto.Association.NotLoaded}), do: nil
  defp participant_list(contact_list), do: contact_list

  defp brand_logo(nil), do: %{url: %{full: "/images/cliizii_logo.png"}, static: true}
  defp brand_logo(brand_logo) do
    render_one(brand_logo, ResourceView, "resource.json")
  end
end
