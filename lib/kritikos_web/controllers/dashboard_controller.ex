defmodule KritikosWeb.DashboardController do
  use KritikosWeb, :controller
  use KritikosWeb.GuardedController

  plug KritikosWeb.Plug.EnsureAuthenticated

  def home(conn, _params, _user) do
    render(conn, "home.html")
  end
end
