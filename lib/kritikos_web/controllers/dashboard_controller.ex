defmodule KritikosWeb.DashboardController do
  use KritikosWeb, :controller
  use KritikosWeb.GuardedController

  plug KritikosWeb.Plug.EnsureAuthenticated
  plug :put_layout, "header.html"

  plug KritikosWeb.Plug.PutAssigns, button: %{id: "log-out", href: "/", text: "Log out"}

  def dashboard(conn, _params, _user) do
    render(conn, "dashboard.html")
  end

  def new_session(conn, _params, _user) do
    render(conn, "new_session.html", keyword: "hi")
  end

  def previous_sessions(conn, _params, _user) do
    render(conn, "previous_sessions.html")
  end

  def all_sessions(conn, _params, _user) do
    render(conn, "all_sessions.html")
  end
end
