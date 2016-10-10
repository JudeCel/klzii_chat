defmodule KlziiChat.DatabasMonitoring.Listener do
  use Boltun, otp_app: :klzii_chat

  listen do
    channel "table_update", :session_topics
  end

  def session_topics(channel, payload) do
    IO.puts channel
    IO.puts payload
  end
end
