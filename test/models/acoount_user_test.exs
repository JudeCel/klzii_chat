defmodule KlziiChat.AcoountUserTest do
  use KlziiChat.ModelCase

  alias KlziiChat.{AcoountUser, User, Account, Repo}


  # @valid_account_attrs %{name: "some content"}
  # @valid_user_attrs %{email: "some content", encryptedPassword: "some content"}
  #
  # @valid_attrs %{}
  # @invalid_attrs %{}

  test "Can make a query" do

    AcoountUser |> Repo.all |> IO.inspect 
  end

  test "changeset with invalid attributes" do
  end
end
