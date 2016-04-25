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
    # CORS Routes
    options "/", ResourcesController, :index
    options "/ping", ResourcesController, :ping
    options "/zip", ResourcesController, :zip
    options "/upload", ResourcesController, :upload
    options "/delete", ResourcesController, :delete
    options "/:id", ResourcesController, :show

    # Generic routes for API be call from original domain
    get "/", ResourcesController, :index
    get "/ping", ResourcesController, :ping
    post "/zip", ResourcesController, :zip
    post "/upload", ResourcesController, :upload
    delete "/delete", ResourcesController, :delete
    get "/:id", ResourcesController, :show
  end

  scope "api/surveys", KlziiChat do
    pipe_through :api
    # CORS Routes
    options "/:id", SurveysController, :show
    # Generic routes for API be call from original domain
    get "/:id", SurveysController, :show
  end


  # Other scopes may use custom stacks.
  # scope "/api", KlziiChat do
  #   pipe_through :api
  # end
end
