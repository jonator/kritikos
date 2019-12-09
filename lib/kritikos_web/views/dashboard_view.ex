defmodule KritikosWeb.DashboardView do
  use KritikosWeb, :view

  def render("stylesheets.html", assigns) do
    Routes.static_path(assigns[:conn], "/css/dashboard.css")
  end

  def render("scripts.html", assigns) do
    Routes.static_path(assigns[:conn], "/js/dashboard.js")
  end

  def render_overall_feedback(overall_feedback) do
    case overall_feedback do
      :empty ->
        ~E(<span>No votes</span>)

      overall_feedback when is_binary(overall_feedback) ->
        svg_image(overall_feedback, class: overall_feedback <> " smiley")
    end
  end

  def correlated_vote_from_text(text, votes) do
    Enum.find(votes, fn v -> v.id == text.vote_id end)
  end

  def pretty_print_date_time(date_time) do
    year =
      if DateTime.utc_now().year == date_time.year do
        ""
      else
        "/#{date_time.year}"
      end

    hour =
      if date_time.hour < 12 do
        " #{date_time.hour}"
      else
        " #{date_time.hour - 12}"
      end

    minutes =
      if date_time.minute < 10 do
        ":0#{date_time.minute}"
      else
        ":#{date_time.minute}"
      end

    meridiem =
      if date_time.hour < 12 do
        " am"
      else
        " pm"
      end

    "#{date_time.month}/#{date_time.day}" <> year <> hour <> minutes <> meridiem
  end

  def vote_data_js_object(votes) do
    {:ok, json} =
      Enum.map(votes, fn vote ->
        Map.from_struct(vote)
        |> Map.drop([:__meta__])
      end)
      |> Jason.encode(escape: :javascript_safe, pretty: true)

    {:safe, json}
  end

  def vote_levels_js_object(vote_levels) do
    vote_levels_svg =
      Enum.map(vote_levels, fn {id, name} ->
        {:safe, svg} = svg_image(name)
        {id, svg}
      end)
      |> Map.new()

    {:ok, json} = Jason.encode(vote_levels_svg, escape: :javascript_safe, pretty: true)

    {:safe, json}
  end
end
