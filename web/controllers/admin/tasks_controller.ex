defmodule KlziiChat.Admin.TasksController do
  use KlziiChat.Web, :controller
  alias KlziiChat.Services.SessionReportingService
  alias KlziiChat.Services.ResourceService
  alias KlziiChat.Services.PackageUpdateService

  def index(conn, _) do
    put_layout(conn, "admin.html")
    |> render("index.html")
  end

  def recalculate_all_images(conn, _) do
    { :ok } = ResourceService.recalculate_all_images()
    put_layout(conn, "admin.html")
    |> render("index.html")
  end

  def delete_all_report(conn, _) do
    {count, _} = SessionReportingService.delete_all()
    put_layout(conn, "admin.html")
    |> render("delete_all_report.html", count: count)
  end

  def find_package_updates(conn, _) do
    { :ok, list } = PackageUpdateService.find

    [ok: mix, ok: yarn, ok: node] = Enum.map(list, fn({ key, value }) -> value end)

    put_layout(conn, "admin.html")
    |> render("find_package_updates.html", mix: mix, yarn: yarn, node: node)
  end
end
