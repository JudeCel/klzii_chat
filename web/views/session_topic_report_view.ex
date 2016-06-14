defmodule KlziiChat.SessionTopicReportView do
  use KlziiChat.Web, :view
  # alias KlziiChat.ResourceView

  def render("show.json", %{report: report})do
    %{
      id: report.id,
      # resource: Phoenix.View.render_one(session_resource.resource, ResourceView, "resource.json")
    }
  end
end
