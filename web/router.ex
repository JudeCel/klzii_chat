defmodule KlziiChat.Router do
  use KlziiChat.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Corsica, origins: [~r{^https?://(.*\.?)focus\.com}],
      allow_headers: ~w(accept cache-control pragma)
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource
  end

  scope "/", KlziiChat do
    pipe_through :browser # Use the default browser stack
    get "/", ChatController, :index
  end

  scope "/", KlziiChat do
    get "/ping", PingController, :index
  end

  scope "api/resources", KlziiChat do
    pipe_through :api
    options "/ping", ResourcesController, :ping
    options "/upload", ResourcesController, :upload
    options "/:type", ResourcesController, :index
  end


  # Other scopes may use custom stacks.
  # scope "/api", KlziiChat do
  #   pipe_through :api
  # end
end
