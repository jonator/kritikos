defmodule KritikosWeb.DashboardView do
  use KritikosWeb, :view
  alias KritikosWeb.FormatHelpers

  def format_session(session) do
    FormatHelpers.format_map_with_keys(session, [
      :id,
      :keyword,
      :prompt_question,
      :start_datetime,
      :end_datetime,
      :tags,
      :votes
    ])
  end

  def render("stylesheets.html", assigns) do
    Routes.static_path(assigns[:conn], "/css/dashboard.css")
  end

  def render("scripts.html", assigns) do
    Routes.static_path(assigns[:conn], "/js/dashboard.js")
  end
end
