defmodule KritikosWeb.LandingController do
  use KritikosWeb, :controller

  def landing(conn, _params) do
    button =
      if get_session(conn, :user) != nil do
        %{
          id: "dashboard",
          href: "/dashboard",
          text: "Dashboard"
        }
      else
        %{
          id: "portal",
          href: "/portal",
          text: "Log in"
        }
      end

    conn
    |> render("landing.html", button: button)
  end

  def portal(conn, _params) do
    conn
    |> render("portal.html")
  end
end
