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
    plug :fetch_session
  end

  scope "/dashboard", KritikosWeb do
    pipe_through [:browser]

    get "/", DashboardController, :home
  end

  scope "/api", KritikosWeb do
    pipe_through [:api]

    post "/users/login", SessionController, :create
    post "/users/logout", SessionController, :drop
    post "/user", UserController, :create
    put "/user", UserController, :update
  end

  scope "/", KritikosWeb do
    pipe_through [:browser]

    get "/", LandingController, :landing
    get "/portal", LandingController, :portal
    get "/:keyword", PromptController, :live_session
    get "/kiosk/:keyword", PromptController, :kiosk_live_session
  end
end
