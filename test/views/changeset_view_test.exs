defmodule KlziiChat.ChangesetViewTest do
  use KlziiChat.ConnCase, async: true
  alias KlziiChat.ChangesetView

  test "render custom error with changeset backend" do
    error_message = "Action not allowed!"
    resp = ChangesetView.render("error.json", %{permissions: error_message})
    assert(resp == %{errors: %{permissions: [error_message]}})
  end
end
