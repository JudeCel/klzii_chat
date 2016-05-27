defmodule KlziiChat.Decorators.MessageDecoratorTest do
  use ExUnit.Case, async: true
  alias  KlziiChat.Decorators.MessageDecorator

  test "votes count" do
    result = MessageDecorator.votes_count([%{}, %{}])
    assert(result == 2)
  end

  test "when has voted" do
    id = 2
    list = [%{sessionMemberId: id}, %{sessionMemberId: 4}]
    MessageDecorator.has_voted(list, id) |> assert
  end

  test "when not voted" do
    id = 2
    list = [%{sessionMemberId: 3}, %{sessionMemberId: 4}]
    MessageDecorator.has_voted(list, id) |> refute
  end

  test "get emotion name" do
    assert(MessageDecorator.emotion_name(0) == "Smiling")
    assert(MessageDecorator.emotion_name(6) == "Sleepy")
  end

  test "get emotion name error with incorrect id" do
    assert(MessageDecorator.emotion_name(-1) == :error)
    assert(MessageDecorator.emotion_name(7) == :error) 
  end
end
