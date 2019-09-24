defmodule KritikosWeb.DashboardController do
  use KritikosWeb, :controller
  use KritikosWeb.GuardedController

  plug KritikosWeb.Plug.EnsureAuthenticated
  plug :put_layout, "header.html"

  plug KritikosWeb.Plug.PutAssigns, button: %{id: "log-out", href: "/", text: "Log out"}

  def home(conn, _params, _user) do
    render(conn, "home.html")
  end

  def new_session(conn, _params, _user) do
    IO.inspect(conn)
    render(conn, "new_session.html")
  end
end
