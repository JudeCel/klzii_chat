defmodule KlziiChat.Helpers.UrlHelper do

  @spec auth_redirect_url(String) :: String
  def auth_redirect_url(token) do
    KlziiChat.Router.Helpers.chat_url(KlziiChat.Endpoint, :index, token: token)
  end
end
