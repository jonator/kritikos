defmodule KritikosWeb.DashboardView do
  use KritikosWeb, :view

  def render("stylesheets.html", assigns) do
    Routes.static_path(assigns[:conn], "/css/dashboard.css")
  end

  def render("scripts.html", assigns) do
    Routes.static_path(assigns[:conn], "/js/dashboard.js")
  end

  def summary_verdict(verdict) do
    case verdict do
      :empty ->
        ~E(<span>No votes</span>)

      verdict when is_binary(verdict) ->
        svg_image(verdict, class: verdict)
    end
  end

  def correlated_vote_from_text(text, votes) do
    Enum.find(votes, fn v -> v.id == text.vote_id end)
  end
end
