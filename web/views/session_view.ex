defmodule KlziiChat.SessionView do
  use KlziiChat.Web, :view

  def render("session.json", %{session: session}) do
    %{id: session.id,
      name: session.name,
      start_time: session.start_time,
      end_time: session.end_time
    }
  end
end
