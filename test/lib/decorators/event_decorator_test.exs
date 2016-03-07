defmodule KlziiChat.Decorators.EventDecoratorTest do
  use ExUnit.Case, async: true
  alias  KlziiChat.Decorators.EventDecorator

  test "votes count" do
    result = EventDecorator.votes_count([%{}, %{}])
    assert(result == 2)
  end

  test "when has voted" do
    id = 2
    list = [%{sessionMemberId: id}, %{sessionMemberId: 4}]
    EventDecorator.has_voted(list, id) |> assert
  end

  test "when not voted" do
    id = 2
    list = [%{sessionMemberId: 3}, %{sessionMemberId: 4}]
    EventDecorator.has_voted(list, id) |> refute
  end
end
