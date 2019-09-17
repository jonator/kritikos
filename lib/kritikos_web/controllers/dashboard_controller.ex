defmodule KritikosWeb.DashboardController do
  use KritikosWeb, :controller

  def home(conn, _params) do
    render(conn, "home.html")
  end
end
