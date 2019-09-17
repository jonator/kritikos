defmodule KritikosWeb.LandingView do
  use KritikosWeb, :view

  def render("stylesheets.html", assigns) do
    Routes.static_path(assigns[:conn], "/css/landing.css")
  end

  def render("scripts.html", assigns) do
    Routes.static_path(assigns[:conn], "/js/landing.js")
  end
end
