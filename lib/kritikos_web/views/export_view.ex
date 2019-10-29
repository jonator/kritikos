defmodule KritikosWeb.ExportView do
  use KritikosWeb, :view

  def render("stylesheets.html", assigns) do
    Routes.static_path(assigns[:conn], "/css/export.css")
  end

  def render("scripts.html", assigns) do
    Routes.static_path(assigns[:conn], "/js/export.js")
  end

  def host_url(endpoint) do
    {:host, host} =
      List.keyfind(Application.get_env(:kritikos, KritikosWeb.Endpoint)[:url], :host, 0)

    host <> "/" <> endpoint
  end
end
