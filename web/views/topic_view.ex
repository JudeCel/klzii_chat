defmodule KlziiChat.TopicView do
  use KlziiChat.Web, :view

  def render("topic.json", %{topic: topic}) do
    %{id: topic.id,
      name: topic.name
    }
  end
end
