defmodule KritikosWeb.DashboardView do
  use KritikosWeb, :view
  alias KritikosWeb.FormatHelpers

  def format_session(session) do
    FormatHelpers.format_map_with_keys(session, [
      :id,
      :name,
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

  def vote_data_js_object do
    votes = Kritikos.Repo.all(Kritikos.Votes.VoteLevel)

    {:ok, json} =
      Enum.map(votes, fn vote ->
        {:safe, svg} = svg_image(vote.description)

        Map.from_struct(vote)
        |> Map.put(:svg, svg)
        |> Map.drop([:__meta__])
      end)
      |> Jason.encode(escape: :javascript_safe, pretty: true)

    {:safe, json}
  end
end
