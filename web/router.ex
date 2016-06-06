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

  scope "/api/resources", KlziiChat do
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

  scope "/api/surveys", KlziiChat do
    pipe_through :api
    # CORS Routes
    options "/:id", SurveysController, :show
    # Generic routes for API be call from original domain
    get "/:id", SurveysController, :show
  end

  scope "/api/banners", KlziiChat do
    pipe_through :api
    # CORS Routes
    options "/", BannersController, :index
    # Generic routes for API be call from original domain
    get "/", BannersController, :index
  end

  scope "/api/mini_surveies", KlziiChat do
    pipe_through :api
    # CORS Routes
    options "/", MiniSurveiesController, :index
    options "/", MiniSurveiesController, :create
    options "/:id/answer/", MiniSurveiesController, :answer
    # Generic routes for API be call from original domain
    get "/", MiniSurveiesController, :index
    post "/", MiniSurveiesController, :create
    post "/:id/answer/", MiniSurveiesController, :answer
  end

  scope "/api/auth", KlziiChat do
    pipe_through :api
    # CORS Routes
    options "/token", AuthController, :token
    # Generic routes for API be call from original domain
    get "/token",AuthController, :token
  end

  scope "/api/session_resources", KlziiChat do
    pipe_through :api
    options "/", SessionResourcesController, :index
    options "/create", SessionResourcesController, :create
    options "/gallery", SessionResourcesController, :gallery
    options "/upload", SessionResourcesController, :upload
    options "/:id", SessionResourcesController, :delete

    get "/", SessionResourcesController, :index
    post "/create", SessionResourcesController, :create
    post "/upload", SessionResourcesController, :upload
    get "/gallery", SessionResourcesController, :gallery
    delete "/:id", SessionResourcesController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", KlziiChat do
  #   pipe_through :api
  # end
end
