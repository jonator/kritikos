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
    plug :put_secure_browser_headers
  end

  scope "/", KritikosWeb do
    pipe_through [:browser]

    get "/", LandingController, :landing
    get "/portal", LandingController, :portal
    get "/dashboard", DashboardController, :dashboard
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
    patch "/user/password", UserController, :update_password
    post "/vote/:keyword/:level", PromptController, :submit_vote
    post "/:keyword/submit_form", PromptController, :submit_feedback
    post "/closeCurrentSession", DashboardController, :close_current_session
    post "/sessions/start", SessionsController, :start_session
    post "/sessions/:keyword/end", SessionsController, :end_session
    get "/sessions/:keyword", SessionsController, :get_session
    get "/sessions/:keyword/export/qr", SessionsController, :export_session_qr
  end
end
