defmodule KritikosWeb.Router do
  use KritikosWeb, :router
  import Phoenix.LiveDashboard.Router

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

  pipeline :admin do
    plug KritikosWeb.Plug.AdminOnly, email: "jonathanator0@gmail.com"
  end

  scope "/admin" do
    pipe_through [:browser, :admin]

    live_dashboard "/dashboard"

    if Mix.env() == :dev do
      forward "/sent_emails", Bamboo.SentEmailViewerPlug
    end
  end

  scope "/", KritikosWeb do
    pipe_through [:browser]

    get "/", LandingController, :landing
    get "/portal", PortalController, :portal
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
    post "/user/verify_email", UserController, :verify_email
    post "/vote/:keyword/:level", PromptController, :submit_vote
    post "/:keyword/submit_form", PromptController, :submit_feedback
    post "/closeCurrentSession", DashboardController, :close_current_session
    post "/sessions/start", SessionsController, :start_session
    post "/sessions/:keyword/end", SessionsController, :end_session
    post "/sessions/:session_id/delete", SessionsController, :delete_session
    get "/sessions/:keyword", SessionsController, :get_session
    get "/sessions/:keyword/export/qr", SessionsController, :export_session_qr
    get "/billing/create_checkout_session", StripeController, :create_checkout_session
    get "/billing/create_billing_session", StripeController, :create_billing_session
  end
end
