defmodule KritikosWeb.DashboardView do
  use KritikosWeb, :view

  def render("stylesheets.html", assigns) do
    Routes.static_path(assigns[:conn], "/css/dashboard.css")
  end

  def render("scripts.html", assigns) do
    Routes.static_path(assigns[:conn], "/js/dashboard.js")
  end

  def correlated_vote_from_text(text, votes) do
    Enum.find(votes, fn v -> v.id == text.vote_id end)
  end

  def vote_data_js_object(votes) do
    Enum.map(votes, fn vote ->
      Map.from_struct(vote)
      |> Map.drop([:__meta__])
    end)
    |> to_js_object()
  end

  def vote_levels_js_object(vote_levels) do
    Enum.map(vote_levels, fn {id, name} ->
      {:safe, svg} = svg_image(name)
      {id, svg}
    end)
    |> Map.new()
    |> to_js_object()
  end
end
