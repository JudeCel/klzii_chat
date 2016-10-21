defmodule KlziiChat.SessionView do
  use KlziiChat.Web, :view
  alias KlziiChat.{SessionTopicView, ResourceView, AccountView}

  def render("session.json", %{session: session}) do
    %{id: session.id,
      name: session.name,
      type: session.type,
      startTime: session.startTime,
      endTime: session.endTime,
      colours: brand_project_preference(session.brand_project_preference),
      brand_logo: brand_logo(session.brand_logo),
      session_topics: session_topics(session.session_topics, :default),
      timeZone: session.timeZone,
      account: account(session.account)
    }
  end

  def render("report.json", %{session: session}) do
    %{id: session.id,
      name: session.name,
      type: session.type,
      startTime: session.startTime,
      endTime: session.endTime,
      colours: brand_project_preference(session.brand_project_preference),
      brand_logo: brand_logo(session.brand_logo),
      session_topics: session_topics(session.session_topics, :report),
      timeZone: session.timeZone,
      account: account(session.account)
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

  defp session_topics(%{__struct__: Ecto.Association.NotLoaded},_), do: []
  defp session_topics(topics, :report) do
    render_many(topics, SessionTopicView, "report.json", as: :session_topic)
  end
  defp session_topics(topics,_) do
    render_many(topics, SessionTopicView, "show.json", as: :session_topic)
  end

  defp account(%{__struct__: Ecto.Association.NotLoaded}), do: nil
  defp account(account) do
    render_one(account, AccountView, "show.json", as: :account)
  end

  defp brand_logo(nil), do: %{url: %{full: "/images/klzii_logo.png"}, static: true}
  defp brand_logo(brand_logo) do
    render_one(brand_logo, ResourceView, "resource.json")
  end
end
