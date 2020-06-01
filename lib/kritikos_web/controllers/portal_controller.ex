defmodule KritikosWeb.PortalController do
  use KritikosWeb, :controller

  def portal(conn, %{"ref" => referrer_path}) do
    conn
    |> render("portal.html", ref: referrer_path)
  end

  def portal(conn, _params) do
    portal(conn, %{"ref" => nil})
  end
end
