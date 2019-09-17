defmodule KritikosWeb.LandingController do
  use KritikosWeb, :controller

  plug :put_layout, "header.html"

  def landing(conn, _params) do
    render(conn, "landing.html")
  end

  def portal(conn, _params) do
    conn
    |> put_layout("app.html")
    |> render("portal.html")
  end
end
