defmodule KlziiChat.SessionResourcesView do
  use KlziiChat.Web, :view

  def render("session_resources.json", %{session_resources_ids: session_resources_ids})do
    %{session_resources_ids: session_resources_ids}
  end
end
