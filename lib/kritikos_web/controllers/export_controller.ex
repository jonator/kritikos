defmodule KritikosWeb.ExportController do
  use KritikosWeb, :controller
  use KritikosWeb.GuardedController

  plug KritikosWeb.Plug.EnsureAuthenticated
  plug :put_layout, "header.html"
  plug KritikosWeb.Plug.PutAssigns, button: %{id: "log-out", href: "/", text: "Log out"}

  def export_options(conn, _params, _user) do
    render(conn, "export.html")
  end

  def fullscreen(conn, _params, _user) do
  end
end
