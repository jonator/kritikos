defmodule KritikosWeb.Router do
  use KritikosWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Kritikos.Plug.NoCache
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  scope "/dashboard", KritikosWeb do
    pipe_through [:browser]

    get "/", DashboardController, :dashboard
    get "/newSession", DashboardController, :new_session
    get "/previousSessions", DashboardController, :previous_sessions
    get "/previousSessions/:keyword", DashboardController, :previous_session
    get "/allSessions", DashboardController, :all_sessions
    get "/currentSession", DashboardController, :current_session
  end

  scope "/", KritikosWeb do
    pipe_through [:browser]

    get "/", LandingController, :landing
    get "/portal", LandingController, :portal
    get "/:keyword", PromptController, :live_session
    get "/:keyword/form", PromptController, :live_session_form
    get "/:keyword/thanks", PromptController, :thanks
    get "/kiosk/:keyword", PromptController, :kiosk_live_session
  end

  scope "/api", KritikosWeb do
    pipe_through [:api]

    post "/users/login", SessionController, :create
    post "/users/logout", SessionController, :drop
    post "/user", UserController, :create
    put "/user", UserController, :update
    post "/vote/:keyword/:level", PromptController, :vote
    post "/:keyword/submit_form", PromptController, :submit_form
    post "/closeCurrentSession", DashboardController, :close_current_session
  end
end
