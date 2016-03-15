defmodule KlziiChat.Services.ResourceService do
  alias KlziiChat.{Repo, Topic, Resource, ResourceView}
  import Ecto
  import Ecto.Query

  def get(topic_id, type, scope) do
    topic = Repo.get!(Topic, topic_id)
    resources = Repo.all(
      from e in assoc(topic, :resources),
        where: [type: ^type, scope: ^scope]
    )
    resp = Enum.map(resources, fn resource ->
      ResourceView.render("resource.json", %{resource: resource})
    end)

    {:ok, resp}
  end

end
