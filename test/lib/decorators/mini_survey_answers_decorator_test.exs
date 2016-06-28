defmodule KlziiChat.Decorators.MiniSurveyAnswersDecoratorTest do
  use ExUnit.Case, async: true
  alias  KlziiChat.Decorators.MiniSurveyAnswersDecorator

  test "Get text answer by ID for yesNoMaybe type" do
    assert(MiniSurveyAnswersDecorator.answer_text("yesNoMaybe", 1) == {:ok, "Yes"})
    assert(MiniSurveyAnswersDecorator.answer_text("yesNoMaybe", "3") == {:ok, "Maybe"})

    assert(MiniSurveyAnswersDecorator.answer_text("yesNoMaybe", "0") == {:error, "incorrect answer id"})
    assert(MiniSurveyAnswersDecorator.answer_text("yesNoMaybe", 4) == {:error, "incorrect answer id"})
  end

  test "Get text answer by ID for 5starRating type" do
    assert(MiniSurveyAnswersDecorator.answer_text("5starRating", 1) == {:ok, "1 star"})
    assert(MiniSurveyAnswersDecorator.answer_text("5starRating", "5") == {:ok, "5 stars"})

    assert(MiniSurveyAnswersDecorator.answer_text("5starRating", "0") == {:error, "incorrect answer id"})
    assert(MiniSurveyAnswersDecorator.answer_text("5starRating", 6) == {:error, "incorrect answer id"})
  end
end
