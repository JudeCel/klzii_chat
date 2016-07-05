defmodule KlziiChat.ChangesetView do
  use KlziiChat.Web, :view

  @doc """
  Traverses and translates changeset errors.

  See `Ecto.Changeset.traverse_errors/2` and
  `KlziiChat.ErrorHelpers.translate_error/1` for more details.
  """
  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end

  def render("error.json", %{changeset: changeset}) do
    # When encoded, the changeset returns its errors
    # as a JSON object. So we just pass it forward.
    %{errors: translate_errors(changeset)}
  end
  def render("error.json", %{permissions: error_message}) do
    %{errors: %{permissions: [translate_error(error_message)]}}
  end
  def render("error.json", %{not_found: error_message}) do
    %{errors: %{permissions: [translate_error(error_message)]}}
  end
  def render("error.json", %{type: error_message}) do
    %{errors: %{permissions: [translate_error(error_message)]}}
  end
  def render("error.json", %{format: error_message}) do
    %{errors: %{permissions: [translate_error(error_message)]}}
  end
end
