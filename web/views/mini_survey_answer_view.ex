defmodule KlziiChat.MiniSurveyAnswerView do
  use KlziiChat.Web, :view
  alias KlziiChat.SessionMembersView

  @spec render(String.t, Map.t) :: Map.t
  def render("show.json", %{mini_survey_answer: mini_survey_answer}) do
    %{
      id: mini_survey_answer.id,
      answer: mini_survey_answer.answer,
      session_member: render_one(mini_survey_answer.session_member, SessionMembersView, "member.json", as: :member),
      createdAt: mini_survey_answer.createdAt
    }
  end
  @spec render(String.t, Map.t) :: Map.t
  def render("report.json", %{mini_survey_answer: mini_survey_answer}) do
    %{
      id: mini_survey_answer.id,
      answer: mini_survey_answer.answer,
      session_member: render_one(mini_survey_answer.session_member, SessionMembersView, "report.json", as: :member),
      createdAt: mini_survey_answer.createdAt
    }
  end
end
