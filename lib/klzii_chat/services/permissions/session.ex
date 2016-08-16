defmodule KlziiChat.Services.Permissions.Session do
  alias KlziiChat.{Session, SessionMember, AccountUser}

  @spec can_access?(%AccountUser{}, %SessionMember{}, %Session{}) :: {:ok} | {:error, String.t}
  def can_access?(%AccountUser{role: "accountManager"}, %SessionMember{role: "facilitator"}, %Session{}) do
    {:ok}
  end
  @spec can_access?(%AccountUser{}, %SessionMember{}, %Session{}) :: {:ok} | {:error, String.t}
  def can_access?(%AccountUser{role: "accountManager"}, %SessionMember{role: "participant"}, %Session{}) do
    {:ok}
  end
  @spec can_access?(%AccountUser{}, %SessionMember{}, %Session{}) :: {:ok} | {:error, String.t}
  def can_access?(%AccountUser{role: "accountManager"}, %SessionMember{role: "observer"}, %Session{status: status}) when status in ["open", "close"] do
    {:ok}
  end
  @spec can_access?(%AccountUser{}, %SessionMember{}, %Session{}) :: {:ok} | {:error, String.t}
  def can_access?(%AccountUser{role: _}, %SessionMember{role: "facilitator"}, %Session{}) do
    {:ok}
  end
  @spec can_access?(%AccountUser{}, %SessionMember{}, %Session{}) :: {:ok} | {:error, String.t}
  def can_access?(%AccountUser{role: _}, %SessionMember{role: "participant"}, %Session{status: "open"}) do
    {:ok}
  end
  @spec can_access?(%AccountUser{}, %SessionMember{}, %Session{}) :: {:ok} | {:error, String.t}
  def can_access?(%AccountUser{role: _}, %SessionMember{role: "observer"}, %Session{status: status}) when status in ["open", "close"] do
    {:ok}
  end
  def can_access?(_account_user, _session_member, session) do
    {:error, %{permissions: "Session status: #{session.status}", code: 401}}
  end
end
