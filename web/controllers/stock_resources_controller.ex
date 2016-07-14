defmodule KlziiChat.StockResourcesController do
  use KlziiChat.Web, :controller
  alias KlziiChat.{ResourceView}
  alias KlziiChat.Queries.Resources, as: QueriesResources

  def index(conn, params) do
    resources =
      QueriesResources.base_resource_query()
      |> QueriesResources.find_by_params(params)
      |> QueriesResources.stock_query(true)
      |> Repo.all
      |> Enum.map(fn resource ->
        ResourceView.render("resource.json", %{resource: resource})
      end)
    json(conn, %{resources: resources})
  end
end
