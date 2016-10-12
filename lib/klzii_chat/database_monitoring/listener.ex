defmodule KlziiChat.DatabaseMonitoring.Listener do
  use Boltun, otp_app: :klzii_chat
  alias KlziiChat.DatabaseMonitoring.{EventParser}

  listen do
    channel "table_update", :processe_event
  end

  def processe_event(channel, payload) do
    EventParser.processe_event(channel, payload)
  end
end
