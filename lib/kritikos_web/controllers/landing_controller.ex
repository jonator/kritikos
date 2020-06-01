defmodule KritikosWeb.LandingController do
  use KritikosWeb, :controller

  def landing(conn, _params) do
    user = get_session(conn, :user)

    conn
    |> render("landing.html", user: user)
  end
end
