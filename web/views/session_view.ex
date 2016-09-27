defmodule KlziiChat.SessionView do
  use KlziiChat.Web, :view
  alias KlziiChat.{SessionTopicView, ResourceView}

  def render("session.json", %{session: session}) do
    %{id: session.id,
      name: session.name,
      type: session.type,
      startTime: session.startTime,
      endTime: session.endTime,
      colours: brand_project_preference(session.brand_project_preference),
      brand_logo: brand_logo(session.brand_logo),
      session_topics: Enum.map(session.session_topics, fn t ->
        SessionTopicView.render("show.json", %{session_topic: t })
      end)
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

  defp brand_logo(nil), do: %{url: %{full: "/images/klzii_logo.png"}}
  defp brand_logo(brand_logo) do
    Phoenix.View.render_one(brand_logo, ResourceView, "resource.json")
  end
end
