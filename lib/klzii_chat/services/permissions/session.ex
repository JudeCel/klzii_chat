defmodule KlziiChat.Services.Permissions.Session do
  alias KlziiChat.{Session, SessionMember, AccountUser}
  use Timex

  @spec can_access?(%AccountUser{}, %SessionMember{}, %Session{}) :: {:ok} | {:error, String.t}
  def can_access?(%AccountUser{role: "accountManager"}, %SessionMember{role: "facilitator"}, %Session{}) do
    {:ok}
  end
  @spec can_access?(%AccountUser{}, %SessionMember{}, %Session{}) :: {:ok} | {:error, String.t}
  def can_access?(%AccountUser{role: "accountManager"}, %SessionMember{role: "participant"}, %Session{}) do
    {:ok}
  end
  @spec can_access?(%AccountUser{}, %SessionMember{}, %Session{}) :: {:ok} | {:error, String.t}
  def can_access?(%AccountUser{role: "accountManager"}, %SessionMember{role: "observer"}, %Session{}) do
    {:ok}
  end
  @spec can_access?(%AccountUser{}, %SessionMember{}, %Session{}) :: {:ok} | {:error, String.t}
  def can_access?(%AccountUser{role: _}, %SessionMember{role: "facilitator"}, %Session{}) do
    {:ok}
  end
  @spec can_access?(%AccountUser{}, %SessionMember{}, %Session{}) :: {:ok} | {:error, String.t}
  def can_access?(%AccountUser{role: _}, %SessionMember{role: "participant"}, %Session{status: "open", startTime: startTime, endTime: endTime}) do
    validate_time(startTime, endTime)
  end
  @spec can_access?(%AccountUser{}, %SessionMember{}, %Session{}) :: {:ok} | {:error, String.t}
  def can_access?(%AccountUser{role: _}, %SessionMember{role: "observer"}, %Session{status: status, startTime: startTime, endTime: endTime}) when status in ["open", "closed"] do
    validate_time(startTime, endTime)
  end
  def can_access?(_account_user, _session_member, session) do
    {:error, %{permissions: "Session is #{String.capitalize(session.status)}", code: 401}}
  end

  @spec validate_time(Timex.t, Timex) :: {:ok} | {:error, map}
  def validate_time(startTime, endTime) do
    now = Timex.now

    cond do
      Timex.after?(now, endTime) ->
        {:error, %{permissions: "Session is Expired", code: 401}}
      Timex.before?(now, startTime) ->
        {:error, %{permissions: "Session is Pending", code: 401}}
      true ->
        {:ok}
    end
  end
end
