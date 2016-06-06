defmodule KlziiChat.MiniSurveiesController do
  use KlziiChat.Web, :controller
  use Guardian.Phoenix.Controller
  alias KlziiChat.Services.{MiniSurveiesService}
  alias KlziiChat.{MiniSurveyView}

  plug Guardian.Plug.EnsureAuthenticated, handler: KlziiChat.Guardian.AuthErrorHandler
  plug :if_current_account_user

  def index(conn, params, member, _) do
    case MiniSurveiesService.get(member.session_member.id, params) do
      {:ok, mini_surveies} ->
        json(conn, %{mini_surveies: Phoenix.View.render_many(mini_surveies, MiniSurveyView, "show.json", as: :mini_survey)})
      {:error, reason} ->
        json(conn, %{status: :error, reason: reason})
    end
  end

  def create(conn, params, member, _) do
    case MiniSurveiesService.create(member.session_member.id, params) do
      {:ok, mini_survey} ->
        json(conn, Phoenix.View.render_one(mini_survey, MiniSurveyView, "show.json", as: :mini_survey))
      {:error, reason} ->
        json(conn, %{status: :error, reason: reason})
    end
  end

  def answer(conn, %{"id" => id, "answer" => answer}, member, _) do
    case MiniSurveiesService.create_answer(member.session_member.id, id, answer) do
      {:ok, mini_survey} ->
        json(conn, %{status: :ok})
      {:error, reason} ->
        json(conn, %{status: :error, reason: reason})
    end
  end

  defp if_current_account_user(conn, opts) do
    if Guardian.Plug.current_resource(conn) do
      conn
    else
      KlziiChat.Guardian.AuthErrorHandler.unauthenticated(conn, opts)
    end
 end
end
