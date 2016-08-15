defmodule KlziiChat.Authorisations.Controller.Session do
  alias KlziiChat.{Repo, Session, SessionMember, AccountUser}
  alias KlziiChat.Queries.Sessions, as: SessionQueries

  @spec authorized?(%AccountUser{}, %SessionMember{}, %Session{}) :: {:ok} | {:error, String.t}
  def authorized?(%AccountUser{role: "accountManager"}, %SessionMember{role: "faciltitator"}, %Session{}) do
    {:ok}
  end
  @spec authorized?(%AccountUser{}, %SessionMember{}, %Session{}) :: {:ok} | {:error, String.t}
  def authorized?(%AccountUser{role: "accountManager"}, %SessionMember{role: "participant"}, %Session{}) do
    {:ok}
  end
  @spec authorized?(%AccountUser{}, %SessionMember{}, %Session{}) :: {:ok} | {:error, String.t}
  def authorized?(%AccountUser{role: "accountManager"}, %SessionMember{role: "observer"}, %Session{status: status}) when status in ["open", "close"] do
    {:ok}
  end
  @spec authorized?(%AccountUser{}, %SessionMember{}, %Session{}) :: {:ok} | {:error, String.t}
  def authorized?(%AccountUser{role: _}, %SessionMember{role: "faciltitator"}, %Session{}) do
    {:ok}
  end
  @spec authorized?(%AccountUser{}, %SessionMember{}, %Session{}) :: {:ok} | {:error, String.t}
  def authorized?(%AccountUser{role: _}, %SessionMember{role: "participant"}, %Session{status: "open"}) do
    {:ok}
  end
  @spec authorized?(%AccountUser{}, %SessionMember{}, %Session{}) :: {:ok} | {:error, String.t}
  def authorized?(%AccountUser{role: _}, %SessionMember{role: "observer"}, %Session{status: status}) when status in ["open", "close"] do
    {:ok}
  end
  def authorized?(account_user, session_member, session) do
    {:error, "errro"}
  end
end
