defmodule KritikosWeb.PortalView do
  use KritikosWeb, :view
  import KritikosWeb.SharedView

  def render("meta.html", _assigns) do
    {:safe,
     "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0\">"}
  end

  def render("stylesheets.html", assigns) do
    Routes.static_path(assigns[:conn], "/css/portal.css")
  end

  def render("scripts.html", assigns) do
    Routes.static_path(assigns[:conn], "/js/portal.js")
  end
end
