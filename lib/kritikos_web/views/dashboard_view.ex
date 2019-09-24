defmodule KritikosWeb.DashboardView do
  use KritikosWeb, :view

  def render("stylesheets.html", assigns) do
    Routes.static_path(assigns[:conn], "/css/dashboard.css")
  end

  def render("scripts.html", assigns) do
    Routes.static_path(assigns[:conn], "/js/dashboard.js")
  end
end
