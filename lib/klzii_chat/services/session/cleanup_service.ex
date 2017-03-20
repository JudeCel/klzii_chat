defmodule KlziiChat.Services.Session.CleanupService do
  alias KlziiChat.{Repo, Resource}
  alias KlziiChat.Services.{ResourceService}
  import Ecto.Query, only: [from: 2]

  def clean_reports() do
    from(r in Resource, left_join: sr in assoc(r, :session_topics_reports),
      where: r.stock == false,
      where: is_nil(sr.id),
      where: r.type == "file" and r.scope in ["csv", "txt", "pdf"],
      select: %{ id: r.id })
    |> Repo.all()
    |> Enum.map(&(&1.id))
    |> ResourceService.deleteByIds()
  end
end
