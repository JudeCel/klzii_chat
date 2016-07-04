defmodule KlziiChat.SessionView do
  use KlziiChat.Web, :view
  alias KlziiChat.SessionTopicView

  def render("session.json", %{session: session}) do
    %{id: session.id,
      name: session.name,
      startTime: session.startTime,
      endTime: session.endTime,
      colours: session.brand_project_preference.colours,
      session_topics: Enum.map(session.session_topics, fn t ->
        SessionTopicView.render("show.json", %{session_topic: t })
      end)
    }
  end

  defp brand_project_preference(nil) do
    %{
       browserBackground: '#EFEFEF ',
       mainBackground: '#FFFFFF ',
       mainBorder: '#F0E935 ',
       font: '#58595B ',
       headerButton: '#4CBFE9 ',
       consoleButtonActive: '#4CB649 ',
    }
  end

  defp brand_project_preference(brand_project_preference), do: brand_project_preference.colours
end
