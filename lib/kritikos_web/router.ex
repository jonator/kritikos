defmodule KritikosWeb.Router do
  use KritikosWeb, :router

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

  pipeline :auth do
    plug Kritikos.Auth.Pipeline
  end

  scope "/", KritikosWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index
    get "/:keyword", PageController, :live_session
    get "/kiosk/:keyword", PageController, :kiosk_live_session
  end

  scope "/api", KritikosWeb do
    pipe_through [:api, :auth]

    post "/users/login", SessionController, :create
    post "/user", UserController, :create
    put "/user", UserController, :update
  end
end
