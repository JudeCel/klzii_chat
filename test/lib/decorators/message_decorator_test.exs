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
end
