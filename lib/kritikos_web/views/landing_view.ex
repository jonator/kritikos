defmodule KritikosWeb.LandingView do
  use KritikosWeb, :view

  def render("stylesheets.html", assigns) do
    Routes.static_path(assigns[:conn], "/css/landing.css")
  end
end
