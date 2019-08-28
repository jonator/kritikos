defmodule KritikosWeb.LandingController do
  use KritikosWeb, :controller

  plug :put_layout, "header.html"

  def landing(conn, _params) do
    render(conn, "landing.html")
  end
end
