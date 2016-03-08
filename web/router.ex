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
  end

  scope "/", KlziiChat do
    pipe_through :browser # Use the default browser stack

    get "/", ChatController, :index
    post "/upload/:resourceType/:user_id/:topic_id", ChatController, :upload
  end

  # Other scopes may use custom stacks.
  # scope "/api", KlziiChat do
  #   pipe_through :api
  # end
end
