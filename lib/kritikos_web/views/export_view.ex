defmodule KritikosWeb.ExportView do
  use KritikosWeb, :view

  def render("stylesheets.html", assigns) do
    Routes.static_path(assigns[:conn], "/css/export.css")
  end

  def render("scripts.html", assigns) do
    Routes.static_path(assigns[:conn], "/js/export.js")
  end
end
