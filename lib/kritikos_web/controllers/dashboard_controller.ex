defmodule KritikosWeb.DashboardController do
  use KritikosWeb, :controller
  use KritikosWeb.GuardedController

  plug KritikosWeb.Plug.EnsureAuthenticated

  def home(conn, _params, _user) do
    log_out_button = %{
      id: "log-out",
      href: "/",
      text: "Log out"
    }

    conn
    |> put_layout("header.html")
    |> render("home.html", button: log_out_button)
  end
end
