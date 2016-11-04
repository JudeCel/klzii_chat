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
    assert(MessageDecorator.emotion_name(0) == {:ok, "sad"})
    assert(MessageDecorator.emotion_name(6) == {:ok, "sleepy"})
  end

  test "get emotion name error with incorrect id" do
    assert(MessageDecorator.emotion_name(-1) == {:error, "incorrect emotion id"})
    assert(MessageDecorator.emotion_name(7) == {:error, "incorrect emotion id"})
  end

  test "get emotion name with correct string id" do
    assert(MessageDecorator.emotion_name("0") == {:ok, "sad"})
    assert(MessageDecorator.emotion_name("6") == {:ok, "sleepy"})
  end

  test "get emotion name error with incorrect string id" do
    assert(MessageDecorator.emotion_name("-1") == {:error, "incorrect emotion id"})
    assert(MessageDecorator.emotion_name("6a") == {:error, "incorrect emotion id"})
    assert(MessageDecorator.emotion_name("abc") == {:error, "incorrect emotion id"})
  end

describe "is_unread MessageDecorator test" do
  test "when is unread" do
    id = 2
    list = [%{sessionMemberId: id}, %{sessionMemberId: 4}]
    MessageDecorator.is_unread(list, id) |> assert
  end

  test "when is read" do
    id = 2
    list = [%{sessionMemberId: 4}]
    MessageDecorator.is_unread(list, id) |> refute
  end
end

end
