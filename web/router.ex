defmodule KlziiChat.Router do
  use KlziiChat.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :admin do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug PlugBasicAuth, validation: &KlziiChat.Plugs.ExqUiAuth.is_authorized/2
  end

  pipeline :exq do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
    plug PlugBasicAuth, validation: &KlziiChat.Plugs.ExqUiAuth.is_authorized/2
    plug ExqUi.RouterPlug, namespace: "exq"
  end

  scope "/admin", KlziiChat.Admin do
    pipe_through :admin
    get "/", DashboardController, :index
    get "/logs", LogsController, :index
    get "/logs/:id", LogsController, :show
    get "/tasks", TasksController, :index
    get "/tasks/delete_all_report", TasksController, :delete_all_report
    get "/tasks/recalculate_all_images", TasksController, :recalculate_all_images
    get "/tasks/find_package_updates", TasksController, :find_package_updates
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource
  end

  pipeline :logger do
    plug :accepts, ["json"]
  end

  scope "/connection-logs", KlziiChat do
    pipe_through :logger
    post "/", ConnectionLogController, :index
  end

  scope "/exq", ExqUi do
    pipe_through :exq
    forward "/", RouterPlug.Router, :index
  end

  scope "/", KlziiChat do
    pipe_through :browser # Use the default browser stack
    get "/", ChatController, :index
    get "/logout", ChatController, :logout
    get "/logout_all", ChatController, :logout_all
  end

  scope "/reporting", KlziiChat.Reporting do
    pipe_through :browser # Use the default browser stack
    get "/recruiter_survey_stats/:id/", PreviewController, :recruiter_survey_stats

    get "/messages/:session_id/:session_topic_id", PreviewController, :messages
    get "/messages/:session_id/", PreviewController, :messages

    get "/messages_stars_only/:session_id/:session_topic_id", PreviewController, :messages_stars_only
    get "/messages_stars_only/:session_id/", PreviewController, :messages_stars_only

    get "/whiteboard/:session_id/:session_topic_id", PreviewController, :whiteboard
    get "/whiteboard/:session_id/", PreviewController, :whiteboard

    get "/mini_survey/:session_id/:session_topic_id", PreviewController, :mini_survey
    get "/mini_survey/:session_id/", PreviewController, :mini_survey
  end

  scope "/", KlziiChat do
    get "/ping", PingController, :index
    post "/mailgun/webhooks", MailgunController, :webhooks
    post "/mailgun/webhooks_info", MailgunController, :info
    get "/mailgun/webhooks_info", MailgunController, :info
  end

  scope "/api/resources", KlziiChat do
    pipe_through :api
    # CORS Routes
    options "/", ResourcesController, :index
    options "/ping", ResourcesController, :ping
    options "/upload", ResourcesController, :upload
    options "/delete", ResourcesController, :delete
    options "/closed_session_delete_check", ResourcesController, :closed_session_delete_check
    options "/:id", ResourcesController, :show

    # Generic routes for API be call from original domain
    get "/", ResourcesController, :index
    get "/ping", ResourcesController, :ping
    post "/upload", ResourcesController, :upload
    delete "/delete", ResourcesController, :delete
    get "/closed_session_delete_check", ResourcesController, :closed_session_delete_check
    get "/:id", ResourcesController, :show
  end

  scope("/api", KlziiChat) do
    pipe_through :api

    scope("/pinboard_resource") do
      options "/", PinboardResourceController, :index
      options "/", PinboardResourceController, :delete
      options "/upload", PinboardResourceController, :upload

      get "/", PinboardResourceController, :index
      delete "/", PinboardResourceController, :delete
      post "/upload", PinboardResourceController, :upload
    end
  end

  scope "/api/surveys", KlziiChat do
    pipe_through :api
    # CORS Routes
    options "/:id", SurveysController, :show
    options "/report/:id/:format/:token", SurveysController, :export
    options "/list_report/:format/:token/?ids=:ids", SurveysController, :export_list
    # Generic routes for API be call from original domain
    get "/:id", SurveysController, :show
    get "/report/:id/:format/:token", SurveysController, :export
    get "/session_report/:id/:format/:token", SurveysController, :export_session_surveys
  end

  scope "/api/banners", KlziiChat do
    pipe_through :api
    # CORS Routes
    options "/", BannersController, :index
    # Generic routes for API be call from original domain
    get "/", BannersController, :index
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
